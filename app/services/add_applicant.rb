# frozen_string_literal: true

module ChitChat
  # Create new configuration for a project
  class AddApplicant
    # Error for owner cannot be co-organizer
    class ForbiddenError < StandardError
      def message
        'You are not allowed to apply for this event'
      end
    end

    def self.call(auth:, event:)
      policy = ApplicantRequestPolicy.new(event, auth[:account], auth[:scope])

      raise ForbiddenError unless policy.can_apply?

      event.add_applicant(auth[:account])

      auth[:account]
    end
  end
end
