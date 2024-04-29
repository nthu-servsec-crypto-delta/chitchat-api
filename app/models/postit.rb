# frozen_string_literal: true

require 'json'
require 'sequel'
require 'sequel/plugins/serialization'

require_relative '../objects/location'

Sequel::Plugins::Serialization.register_format(
  :location_s,
  ChitChat::Location.method(:to_json).to_proc,
  ChitChat::Location.method(:from_json).to_proc
)

module ChitChat
  # Postit with location and message
  class Postit < Sequel::Model
    plugin :timestamps
    plugin :serialization

    serialize_attributes :location_s, :location

    def to_json(options = {})
      JSON(
        {
          id:, location:, message:
        }, options
      )
    end
  end
end
