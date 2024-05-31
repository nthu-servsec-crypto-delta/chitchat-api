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

    plugin :timestamps
    plugin :serialization
    plugin :whitelist_security
    set_allowed_columns :location, :message, :username

    serialize_attributes :location_s, :location

    def to_json(options = {})
      JSON(
        {
          id:, location:, message:
        }, options
      )
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
