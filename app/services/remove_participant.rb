# frozen_string_literal: true

module ChitChat
  # Create new configuration for a project
  class RemoveParticipant
    # Error for owner cannot be co-organizer
    class ForbiddenError < StandardError
      def message
        'You are not allowed to delete that person as participant'
      end
    end

    def self.call(auth:, event:, participant_email:)
      participant = Account.first(email: participant_email)
      policy = ParticipantRequestPolicy.new(event, auth[:account], participant, auth[:scope])

      raise ForbiddenError unless policy.can_remove? || policy.can_leave?

      event.remove_participant(participant)
      participant
    end
  end
end
