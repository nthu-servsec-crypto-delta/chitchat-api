# frozen_string_literal: true

require 'json'
require 'dry-struct'
require 'dry-types'

module ChitChat
  # Location Model
  class Location < Dry::Struct
    include Dry.Types

    attribute :longitude, Coercible::Float
    attribute :latitude, Coercible::Float

    def to_s
      "<long=#{longitude} lat=#{latitude}>"
    end

    def to_json(options = {})
      JSON(to_h, options)
    end

    def to_h(_options = {})
      {
        longitude:,
        latitude:
      }
    end

    # For Sequel serialization
    def self.to_json(location)
      location.to_json
    end

    def self.from_json(json)
      data = ::JSON.parse(json)
      Location.from_h(data)
    end

    def self.from_h(hash)
      Location.new(longitude: hash['longitude'], latitude: hash['latitude'])
    end

    def distance(location)
      # For simplicity, use Euclidean distance here
      Math.sqrt(((longitude - location.longitude)**2) + ((latitude - location.latitude)**2))
    end

    def self.distance(location1, location2)
      location1.distance(location2)
    end
  end
end
