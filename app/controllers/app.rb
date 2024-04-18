# frozen_string_literal: true

require 'roda'
require_relative '../models/location'

module ChitChatApi
  # Main App
  class App < Roda
    plugin :json
    plugin :halt

    route do |r|
      r.root do
        { message: 'It works!' }
      end
    end
  end
end
