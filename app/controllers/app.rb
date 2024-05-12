# frozen_string_literal: true

require 'roda'
require 'json'

module ChitChat
  # Main App
  class Api < Roda
    plugin :halt
    plugin :json
    plugin :multi_route

    def secure_request?(routing)
      routing.scheme.casecmp(Api.config.SECURE_SCHEME).zero?
    end

    route do |routing|
      response['Content-Type'] = 'application/json'

      secure_request?(routing) ||
        routing.halt(403, { message: 'TLS/SSL Required' }.to_json)

      routing.root do
        response.status = 200
        { message: 'ChitChatAPI up at /api/v1' }
      end

      routing.on 'api' do
        routing.on 'v1' do
          @api_root = 'api/v1'
          routing.multi_route
        end
      end
    end
  end
end
