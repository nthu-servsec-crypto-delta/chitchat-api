# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'controllers_common'

module ChitChat
  # Main App
  class Api < Roda
    plugin :halt
    plugin :json
    plugin :multi_route
    plugin :request_headers

    include SecureRequest

    route do |routing|
      response['Content-Type'] = 'application/json'

      secure_request?(routing) ||
        routing.halt(403, { message: 'TLS/SSL Required' }.to_json)

      begin
        @auth_account = authenticated_account(routing.headers)
      rescue AuthToken::InvalidTokenError
        routing.halt 403, { message: 'Invalid auth token' }.to_json
      end

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
