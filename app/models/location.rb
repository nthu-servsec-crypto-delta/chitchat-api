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

    # reference: https://stackoverflow.com/questions/12966638/how-to-calculate-the-distance-between-two-gps-coordinates-without-using-google-m
    def self.distance_between(location1, location2) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      loc1 = [location1.latitude, location1.longitude]
      loc2 = [location2.latitude, location2.longitude]

      rad_per_deg = Math::PI / 180  # PI / 180
      rkm = 6371                    # Earth radius in kilometers
      rm = rkm * 1000               # Radius in meters

      dlat_rad = (loc2[0] - loc1[0]) * rad_per_deg # Delta, converted to rad
      dlon_rad = (loc2[1] - loc1[1]) * rad_per_deg

      lat1_rad, = loc1.map { |i| i * rad_per_deg }
      lat2_rad, = loc2.map { |i| i * rad_per_deg }

      a = (Math.sin(dlat_rad / 2)**2) + (Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad / 2)**2))
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      rm * c # Delta in meters
    end

    def distance_to(location)
      Location.distance_between(self, location)
    end
  end
end
