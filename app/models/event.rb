# frozen_string_literal: true

require 'json'

require 'sequel'
require 'sequel/plugins/serialization'

require_relative '../objects/location'

Sequel::Plugins::Serialization.register_format(
  :location_s,
  ChitChat::Location.method(:to_json),
  ChitChat::Location.method(:from_json)
)

module ChitChat
  # Event Model
  class Event < Sequel::Model
    plugin :timestamps
    plugin :serialization

    serialize_attributes :location_s, :location

    def to_json(options = {})
      JSON(
        {
          id:, name:, description:, location:
        },
        options
      )
    end
  end
end
