# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module ChitChat
  # Main App
  class Api < Roda
    route('postits') do |routing|
      # GET api/v1/postits/[id]
      routing.get String do |postit_id|
        response.status = 200
        postit = Postit.first(id: postit_id)
        postit ? postit.to_json : raise('Postit not found')
      rescue StandardError => e
        routing.halt 404, { message: e.message }
      end

      # GET api/v1/postits
      routing.get do
        response.status = 200
        { postit_ids: Postit.all.map(&:id) }
      end

      # POST api/v1/postits
      routing.post do
        new_data = JSON.parse(routing.body.read)
        new_postit = Postit.create(new_data)

        if new_postit
          response.status = 201
          { message: 'Postit created', id: new_postit.id }
        else
          routing.halt 400, { message: 'Could not create postit' }
        end
      rescue Sequel::MassAssignmentRestriction
        Api.logger.warn "MASS-ASSIGNMENT(POSTIT): #{new_data.keys}"
        routing.halt 400, { message: 'Illegal Attributes' }
      rescue StandardError => e
        Api.logger.error "UNKNOWN ERROR: #{e.message}"
        routing.halt 500, { message: 'Unknown server error' }
      end
    end
  end
end
