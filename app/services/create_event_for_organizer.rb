# frozen_string_literal: true

module ChitChat
  # Service object to create a new project for an owner
  class CreateEventForOrganizer
    # Error for when a user is not allowed to create an event
    class ForbiddenError < StandardError
      def message
        'You are not allowed to create events'
      end
    end

    def self.call(auth:, event_data:)
      raise ForbiddenError unless auth[:scope].can_write?('events')

      auth[:account].add_owned_event(event_data)
    end
  end
end
