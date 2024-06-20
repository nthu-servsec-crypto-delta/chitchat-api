# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module ChitChat
  # Main App
  class Api < Roda # rubocop:disable Metrics/ClassLength
    route('events') do |routing|
      @event_route = "#{@api_root}/events"

      # GET api/v1/events/all
      routing.get 'all' do
        response.status = 200
        events = EventPolicy::AccountScope.new(@auth_account).all
        JSON.pretty_generate(data: events)
      rescue StandardError
        routing.halt 500, { message: 'Unknown error' }.to_json
      end

      routing.on String do |event_id|
        @event = Event.first(id: event_id)

        routing.on('co_organizers') do
          # PUT api/v1/events/[event_id]/co_organizers
          routing.put do
            req_data = JSON.parse(routing.body.read)
            co_organizer = AddCoOrganizer.call(
              auth: @auth,
              event: @event,
              co_organizer_email: req_data['email']
            )
            { data: co_organizer }.to_json
          rescue AddCoOrganizer::ForbiddenError => e
            routing.halt 403, { message: e.message }.to_json
          rescue StandardError
            routing.halt 500, { message: 'API server error' }.to_json
          end

          # DELETE api/v1/events/[event_id]/co_organizers
          routing.delete do
            req_data = JSON.parse(routing.body.read)
            co_organizer = RemoveCoOrganizer.call(
              auth: @auth,
              event: @event,
              co_organizer_email: req_data['email']
            )
            { message: "#{co_organizer.username} removed from event",
              data: co_organizer }.to_json
          rescue RemoveCoOrganizer::ForbiddenError => e
            routing.halt 403, { message: e.message }.to_json
          rescue StandardError
            routing.halt 500, { message: 'API server error' }.to_json
          end
        end

        routing.on('applicants') do
          # PUT api/v1/events/[event_id]/applicants
          routing.put do
            applicant = AddApplicant.call(
              event: @event,
              auth: @auth
            )
            { data: applicant }.to_json
          rescue AddApplicant::ForbiddenError => e
            routing.halt 403, { message: e.message }.to_json
          rescue StandardError
            routing.halt 500, { message: 'API server error' }.to_json
          end

          # DELETE api/v1/events/[event_id]/applicants
          routing.delete do
            applicant = RemoveApplicant.call(
              event: @event,
              auth: @auth
            )
            { data: applicant }.to_json
          rescue RemoveApplicant::ForbiddenError => e
            routing.halt 403, { message: e.message }.to_json
          rescue StandardError
            routing.halt 500, { message: 'API server error' }.to_json
          end
        end

        routing.on('participants') do
          # PUT api/v1/events/[event_id]/participants
          routing.put do
            req_data = JSON.parse(routing.body.read)
            participant = AddParticipant.call(
              event: @event,
              auth: @auth,
              participant_email: req_data['email']
            )
            { data: participant }.to_json
          rescue AddParticipant::ForbiddenError => e
            routing.halt 403, { message: e.message }.to_json
          rescue StandardError
            routing.halt 500, { message: 'API server error' }.to_json
          end

          # DELETE api/v1/events/[event_id]/participants
          routing.delete do
            req_data = JSON.parse(routing.body.read)
            participant = RemoveParticipant.call(
              event: @event,
              auth: @auth,
              participant_email: req_data['email']
            )
            { data: participant }.to_json
          rescue RemoveParticipant::ForbiddenError => e
            routing.halt 403, { message: e.message }.to_json
          rescue StandardError
            routing.halt 500, { message: 'API server error' }.to_json
          end
        end

        routing.on('postits') do
          # GET api/v1/events/[event_id]/postits
          routing.get do
            postits = ChitChat::GetPostitsQuery.call(
              auth: @auth,
              event: @event
            )
            { data: postits }.to_json
          rescue StandardError
            routing.halt 403, { message: 'Could not find any postits' }.to_json
          end

          # POST api/v1/events/[event_id]/postits/
          routing.post do
            new_data = JSON.parse(routing.body.read)
            new_postit = ChitChat::CreatePostitForEvent.call(
              event: @event,
              auth: @auth,
              postit_data: new_data
            )
            response.status = 201
            { message: 'Postit created', id: new_postit.id }
          rescue ChitChat::CreatePostitForEvent::ForbiddenError
            routing.halt 403, { message: 'Forbidden' }
          rescue Sequel::MassAssignmentRestriction
            Api.logger.warn "MASS-ASSIGNMENT(POSTIT): #{new_data.keys}"
            routing.halt 400, { message: 'Illegal Attributes' }
          rescue StandardError => e
            Api.logger.error "UNKNOWN ERROR: #{e.message}"
            routing.halt 500, { message: 'Unknown server error' }
          end
        end

        # GET api/v1/events/[event_id]/accounts
        routing.get 'accounts' do
          response.status = 200
          accounts = EventAccountScope.new(@auth_account, @event, @auth[:scope]).viewable
          JSON.pretty_generate(data: accounts)
        rescue StandardError
          routing.halt 500, { message: 'Unknown error' }.to_json
        end

        # GET api/v1/events/[event_id]
        routing.get do
          response.status = 200
          raise('Event not found') unless @event

          @event.to_h.merge(
            policies: EventPolicy.new(@auth_account, @event, @auth[:scope]).summary
          ).to_json
        rescue StandardError => e
          routing.halt 404, { message: e.message }
        end

        # PUT api/v1/events/[event_id]
        routing.put do
          req_data = JSON.parse(routing.body.read)
          EditEvent.call(auth: @auth, event: @event, new_event_data: req_data)
          { message: 'Event updated' }.to_json
        rescue Sequel::MassAssignmentRestriction
          Api.logger.warn "MASS-ASSIGNMENT(Events): #{req_data.keys}"
          routing.halt 400, { message: 'Illegal Attributes' }
        rescue EditEvent::ForbiddenError => e
          routing.halt 403, { message: e.message }
        rescue StandardError => e
          Api.logger.error "UNKNOWN ERROR: #{e.message}"
          routing.halt 500, { message: 'Unknown error' }
        end

        # DELETE api/v1/events/[event_id]
        routing.delete do
          DeleteEvent.call(auth: @auth, event: @event)
          { message: 'Event deleted' }.to_json
        rescue DeleteEvent::ForbiddenError => e
          routing.halt 403, { message: e.message }
        rescue StandardError
          routing.halt 500, { message: 'Unknown error' }.to_json
        end
      end

      routing.is do
        # GET api/v1/events
        routing.get do
          response.status = 200
          events = EventPolicy::AccountScope.new(@auth_account).with_roles
          { data: events }.to_json
        rescue StandardError
          routing.halt 500, { message: 'Unknown error' }.to_json
        end

        # POST api/v1/events
        routing.post do
          new_data = JSON.parse(routing.body.read)
          new_event = @auth_account.add_owned_event(new_data)

          response.status = 201
          { message: 'Event created', id: new_event.id }
        rescue Sequel::MassAssignmentRestriction
          Api.logger.warn "MASS-ASSIGNMENT(Events): #{new_data.keys}"
          routing.halt 400, { message: 'Illegal Attributes' }
        rescue StandardError => e
          Api.logger.error "UNKNOWN ERROR: #{e.message}"
          routing.halt 500, { message: 'Unknown error' }
        end
      end
    end
  end
end
