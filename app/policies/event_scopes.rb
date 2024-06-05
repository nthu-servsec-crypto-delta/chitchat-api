# frozen_string_literal: true

module ChitChat
  # Policy to determine if account can view other accounts
  class EventScope
    def initialize(account, event)
      @account = account
      @event = event
    end

    # For now all accounts in an event can view all other accounts
    def viewable
      policy = EventPolicy.new(@account, @event).can_view?

      [] unless policy

      all_accounts(@event)
    end

    private

    def all_accounts(event)
      [event.organizer] + event.co_organizers + event.participants
    end
  end
end
