# frozen_string_literal: true

module ChitChat
  # Create new configuration for a project
  class RemoveCoOrganizer
    # Error for owner cannot be co-organizer
    class ForbiddenError < StandardError
      def message
        'You are not allowed to delete that person as co-organizer'
      end
    end

    def self.call(account:, event:, co_organizer_email:)
      co_organizer = Account.first(email: co_organizer_email)
      policy = CoOrganizerRequestPolicy.new(event, account, co_organizer)

      raise ForbiddenError unless policy.can_remove?

      event.remove_co_organizer(co_organizer)
      co_organizer
    end
  end
end