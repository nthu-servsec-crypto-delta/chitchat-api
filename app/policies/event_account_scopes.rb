# frozen_string_literal: true

module ChitChat
  # Policy to determine if account can view other accounts
  class EventAccountScope
    def initialize(account, event)
      @account = account
      @event = event
    end

    # For now all accounts in an event can view all other accounts
    def viewable
      [] unless includes_role?(@event, @account)
      all_accounts(@event)
    end

    private

    def all_accounts(event)
      [event.organizer] + event.co_organizers + event.participants
    end

    def includes_role?(event, account)
      event.organizer == account ||
        event.co_organizers.include?(account) ||
        event.participants.include?(account)
    end
  end
end
