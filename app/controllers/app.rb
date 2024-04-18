# frozen_string_literal: true

require 'roda'
require_relative '../models/location'

module ChitChat
  # Main App
  class Api < Roda
    plugin :json
    plugin :halt

    route do |r|
      r.root do
        { message: 'It works!' }
      end
    end
  end
end
