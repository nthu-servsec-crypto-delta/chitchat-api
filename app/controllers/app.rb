# frozen_string_literal: true

require 'roda'
require 'json'

require_relative '../models/postit'

module ChitChat
  # Main App
  class Api < Roda
    plugin :environments
    plugin :halt
    plugin :json

    configure do
      Postit.setup
    end

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.root do
        response.status = 200
        { message: 'ChitChatAPI up at /api/v1' }
      end

      routing.on 'api' do
        routing.on 'v1' do
          routing.on 'postits' do
            # GET api/v1/postits/[id]
            routing.get String do |id|
              response.status = 200
              Postit.find(id).to_h
            rescue StandardError
              routing.halt 404, { message: 'Postit not found' }
            end

            # GET api/v1/postits
            routing.get do
              response.status = 200
              { postit_ids: Postit.all }
            end

            # POST api/v1/postits
            routing.post do
              new_data = JSON.parse(routing.body.read)
              new_postit = Postit.new(new_data)

              if new_postit.save
                response.status = 201
                { message: 'Postit created', id: new_postit.id }
              else
                routing.halt 400, { message: 'Could not create postit' }
              end
            end
          end
        end
      end
    end
  end
end
