# frozen_string_literal: true

module ChitChat
  # Delete event
  class DeleteEvent
    # Error for when a user is not allowed to delete an event
    class ForbiddenError < StandardError
      def message
        'You are not allowed to delete events'
      end
    end

    def self.call(auth:, event:)
      policy = EventPolicy.new(auth[:account], event, auth[:scope])

      raise ForbiddenError unless policy.can_delete?

      event.destroy
    end
  end
end
