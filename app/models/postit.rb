# frozen_string_literal: true

require 'json'
require 'sequel'

module ChitChat
  # Postit with location and message
  class Postit < Sequel::Model
    plugin :timestamps

    def to_json(options = {})
      JSON(
        {
          id:, location:, message:
        }, options
      )
    end
  end
end
