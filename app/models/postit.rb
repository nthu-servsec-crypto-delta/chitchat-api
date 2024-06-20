# frozen_string_literal: true

require 'json'
require 'sequel'
require 'sequel/plugins/serialization'

require_relative 'location'

Sequel::Plugins::Serialization.register_format(
  :location_s,
  ChitChat::Location.method(:to_json).to_proc,
  ChitChat::Location.method(:from_json).to_proc
)

module ChitChat
  # Postit with location and message
  class Postit < Sequel::Model
    many_to_one :owner, class: :'ChitChat::Account'
    many_to_one :event, class: :'ChitChat::Event'

    plugin :timestamps
    plugin :serialization
    plugin :whitelist_security
    set_allowed_columns :location, :message, :username

    serialize_attributes :location_s, :location

    def to_h
      {
        type: 'postit',
        attributes: {
          id:,
          location:,
          message:,
          event: event_summary
        }
      }
    end

    def event_summary # rubocop:disable Metrics/MethodLength
      return nil unless event

      {
        type: 'event',
        attributes: {
          id: event.id,
          name: event.name,
          location: event.location,
          start_time: event.start_time,
          end_time: event.end_time
        }
      }
    end

    def to_json(options = {})
      JSON(to_h, options)
    end

    def message
      SecureDB.decrypt(message_secure)
    end

    def message=(plaintext)
      self.message_secure = SecureDB.encrypt(plaintext)
    end

    def username=(username)
      # TODO: map this to owner_id
    end
  end
end
