# frozen_string_literal: true

module ChitChat
  # Service object to update location for an account
  class UpdateLocation
    # Error if requesting to see forbidden account
    class ForbiddenError < StandardError
      def message
        'You are not allowed to access the postits in this event'
      end
    end

    def self.call(auth:, location_data:)
      location = Location.from_h(location_data)
      Account.find(username: auth[:account].username).location = location
    end
  end
end
