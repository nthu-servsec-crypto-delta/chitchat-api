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
                                 join_table: :co_organizers_events,
                                 left_key: :event_id, right_key: :account_id
    many_to_many :participants, class: :'ChitChat::Account',
                                join_table: :participants_events,
                                left_key: :event_id, right_key: :account_id
    many_to_many :applicants, class: :'ChitChat::Account',
                              join_table: :applicants_events,
                              left_key: :event_id, right_key: :account_id
    one_to_many :postits, class: :'ChitChat::Postit'

    plugin :timestamps
    plugin :serialization
    plugin :whitelist_security

    set_allowed_columns :name, :description, :location, :radius, :start_time, :end_time
    serialize_attributes :location_s, :location

    def to_h # rubocop:disable Metrics/MethodLength
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
          participants:,
          applicants:,
          postits:
        }
      }
    end

    def location=(new_location)
      self[:location] = new_location.to_json
    end

    def location
      Location.from_json(self[:location])
    end

    def to_json(options = {})
      JSON(
        to_h,
        options
      )
    end
  end
end
