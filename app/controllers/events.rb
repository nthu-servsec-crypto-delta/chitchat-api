# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module ChitChat
  # Main App
  class Api < Roda
    route('events') do |routing|
      @event_route = "#{@api_root}/events"

      # GET api/v1/events/[id]
      routing.get String do |event_id|
        response.status = 200
        event = Event.first(id: event_id)
        event ? event.to_json : raise('Event not found')
      rescue StandardError => e
        routing.halt 404, { message: e.message }
      end

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

      routing.on String do |event_id|
        @event = Event.first(id: event_id)
        routing.on 'participants' do
          # PUT api/v1/events/[event_id]/participants
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
        end
        # DELETE api/v1/events/[event_id]/participants

        # PUT api/v1/events/[event_id]/co_organizers

        # DELETE api/v1/events/[event_id]/co_organizers
      end
    end
  end
end
