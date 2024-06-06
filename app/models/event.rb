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
    many_to_one :organizer, class: :'ChitChat::Account'
    many_to_many :co_organizers, class: :'ChitChat::Account',
                                 join_table: :accounts_events,
                                 left_key: :event_id, right_key: :co_organizer_id
    many_to_many :participants, class: :'ChitChat::Account',
                                join_table: :participations,
                                left_key: :event_id, right_key: :account_id

    plugin :timestamps
    plugin :serialization
    plugin :whitelist_security

    set_allowed_columns :name, :description, :location, :radius, :start_time, :end_time
    serialize_attributes :location_s, :location

    def to_json(options = {}) # rubocop:disable Metrics/MethodLength
      JSON(
        {
          type: 'event',
          attributes: {
            id:,
            name:,
            description:,
            location:,
            radius:,
            start_time:,
            end_time:,
            organizer:,
            co_organizers:,
            participants:
          }
        },
        options
      )
    end
  end
end
