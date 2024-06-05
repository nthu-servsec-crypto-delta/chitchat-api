# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module ChitChat
  # Main App
  class Api < Roda # rubocop:disable Metrics/ClassLength
    route('events') do |routing|
      @event_route = "#{@api_root}/events"

      routing.on String do |event_id|
        @event = Event.first(id: event_id)

        routing.on('co_organizers') do
          # PUT api/v1/events/[event_id]/co_organizers
          routing.put do
            req_data = JSON.parse(routing.body.read)
            co_organizer = AddCoOrganizer.call(
              account: @auth_account,
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
              account: @auth_account,
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
              account: @auth_account,
              event: @event
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
              account: @auth_account,
              event: @event
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
              account: @auth_account,
              event: @event,
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
              account: @auth_account,
              event: @event,
              participant_email: req_data['email']
            )
            { data: participant }.to_json
          rescue RemoveParticipant::ForbiddenError => e
            routing.halt 403, { message: e.message }.to_json
          rescue StandardError
            routing.halt 500, { message: 'API server error' }.to_json
          end
        end

        # GET api/v1/events/[event_id]/accounts
        routing.get 'accounts' do
          response.status = 200
          accounts = EventScope.new(@auth_account, @event).viewable
          JSON.pretty_generate(data: accounts)
        rescue StandardError
          routing.halt 500, { message: 'Unknown error' }.to_json
        end

        # GET api/v1/events/[event_id]
        routing.get do
          response.status = 200
          @event ? @event.to_json : raise('Event not found')
        rescue StandardError => e
          routing.halt 404, { message: e.message }
        end
      end

      routing.is do
        # GET api/v1/events
        routing.get do
          response.status = 200
          { event_ids: Event.all.map(&:id) }
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
