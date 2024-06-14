# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'controllers_common'

module ChitChat
  # Main App
  class Api < Roda
    plugin :halt
    plugin :all_verbs
    plugin :json
    plugin :multi_route
    plugin :request_headers

    include SecureRequest

    UNAUTH_MSG = { message: 'Unauthorized Request' }.to_json

    route do |routing|
      response['Content-Type'] = 'application/json'

      secure_request?(routing) ||
        routing.halt(403, { message: 'TLS/SSL Required' }.to_json)

      begin
        @auth = authorization(routing.headers)
        @auth_account = @auth[:account] if @auth
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
