# frozen_string_literal: true

module ChitChat
  # Create new configuration for a project
  class AddCoOrganizer
    # Error for owner cannot be co-organizer
    class ForbiddenError < StandardError
      def message
        'You are not allowed to invite that person as co-organizer'
      end
    end

    def self.call(auth:, event:, co_organizer_email:)
      invitee = Account.first(email: co_organizer_email)

      policy = CoOrganizerRequestPolicy.new(event, auth[:account], invitee, auth[:scope])

      raise ForbiddenError unless policy.can_invite?

      event.add_co_organizer(invitee)
      invitee
    end
  end
end
