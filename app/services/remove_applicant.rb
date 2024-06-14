# frozen_string_literal: true

module ChitChat
  # Create new configuration for a project
  class RemoveApplicant
    # Error for owner cannot be co-organizer
    class ForbiddenError < StandardError
      def message
        'You are not allowed to cancel applicant for this event'
      end
    end

    def self.call(auth:, event:)
      policy = ApplicantRequestPolicy.new(event, auth[:account], auth[:scope])

      raise ForbiddenError unless policy.can_cancel?

      event.remove_applicant(auth[:account])

      auth[:account]
    end
  end
end
