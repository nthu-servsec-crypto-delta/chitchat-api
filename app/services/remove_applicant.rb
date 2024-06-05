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

    def self.call(account:, event:)
      policy = ApplicantRequestPolicy.new(event, account)

      raise ForbiddenError unless policy.can_cancel?

      Participation.where(account_id: account.id, event_id: event.id).delete

      account
    end
  end
end
