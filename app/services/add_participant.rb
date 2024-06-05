# frozen_string_literal: true

module ChitChat
  # Create new configuration for a project
  class AddParticipant
    # Error for owner cannot be co-organizer
    class ForbiddenError < StandardError
      def message
        'You are not allowed to invite that person as co-organizer'
      end
    end

    def self.call(account:, event:, participant_email:)
      invitee = Account.first(email: participant_email)
      policy = ParticipantRequestPolicy.new(event, account, invitee)

      raise ForbiddenError unless policy.can_approve?

      Participation.first(account_id: invitee.id, event_id: event.id).approved = true

      invitee
    end
  end
end
