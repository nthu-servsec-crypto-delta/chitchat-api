# frozen_string_literal: true

module ChitChat
  # Create new configuration for a project
  class AddCoOrganizer
    # Error for owner cannot be collaborator
    class ForbiddenError < StandardError
      def message
        'You are not allowed to invite that person as collaborator'
      end
    end

    def self.call(account:, event:, co_organizer_email:)
      invitee = Account.first(email: co_organizer_email)
      policy = CoOrganizerRequestPolicy.new(event, account, co_organizer_email)

      raise ForbiddenError unless policy.can_invite?

      event.add_co_organizer(invitee)
    end
  end
end
