# frozen_string_literal: true

module ChitChat
  # User Location Model
  class Location
    def initialize(username, longtidude, latitude)
      @username = username
      @longtidude = longtidude
      @latitude = latitude
    end
  end
end
