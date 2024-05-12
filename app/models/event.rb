# frozen_string_literal: true

require 'json'

require 'sequel'
require 'sequel/plugins/serialization'

require_relative 'location'

Sequel::Plugins::Serialization.register_format(
  :location_s,
  ChitChat::Location.method(:to_json),
  ChitChat::Location.method(:from_json)
)

module ChitChat
  # Event Model
  class Event < Sequel::Model
    many_to_many :accounts, join_table: :participations, left_key: :event_id, right_key: :account_id
    many_to_many :participations

    plugin :timestamps
    plugin :serialization
    plugin :whitelist_security

    set_allowed_columns :name, :description, :location
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
