# frozen_string_literal: true

module ChitChat
  # Service object to get all postits for an event
  class GetPostitsQuery
    # Error if requesting to see forbidden account
    class ForbiddenError < StandardError
      def message
        'You are not allowed to access the postits in this event'
      end
    end

    def self.call(auth:, event:)
      policy = EventPolicy.new(auth[:account], event, auth[:scope])

      raise ForbiddenError unless policy.can_view_postits?

      event.postits
    end
  end
end
