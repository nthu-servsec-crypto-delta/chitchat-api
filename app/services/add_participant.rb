# frozen_string_literal: true

module ChitChat
  # Create new configuration for a project
  class AddParticipant
    # Error for owner cannot be co-organizer
    class ForbiddenError < StandardError
      def message
        'You are not allowed to invite that person as participant'
      end
    end

    def self.call(auth:, event:, participant_email:)
      invitee = Account.first(email: participant_email)

      policy = ParticipantRequestPolicy.new(event, auth[:account], invitee, auth[:scope])

      raise ForbiddenError unless policy.can_approve?

      event.add_participant(invitee)
      event.remove_applicant(invitee)

      invitee
    end
  end
end
