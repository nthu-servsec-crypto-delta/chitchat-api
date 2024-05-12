# frozen_string_literal: true

require 'roda'
require 'json'

module ChitChat
  # Main App
  class Api < Roda
    plugin :halt
    plugin :json
    plugin :multi_route

    route do |routing|
      routing.root do
        response.status = 200
        { message: 'ChitChatAPI up at /api/v1' }
      end

      @api_root = 'api/v1'
      routing.on @api_root do
        routing.multi_route
      end
    end
  end
end
