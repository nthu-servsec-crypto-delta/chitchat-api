# frozen_string_literal: true

require 'roda'
require 'json'

module ChitChat
  # Main App
  class Api < Roda
    plugin :halt
    plugin :json

    route do |routing|
      routing.root do
        response.status = 200
        { message: 'ChitChatAPI up at /api/v1' }
      end

      @api_root = 'api/v1'
      routing.on @api_root do
        routing.on 'postits' do
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
            { postit_ids: Postit.all }
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
          rescue StandardError => e
            puts e.message
            routing.halt 500, { message: 'Database error' }
          end
        end
      end
    end
  end
end
