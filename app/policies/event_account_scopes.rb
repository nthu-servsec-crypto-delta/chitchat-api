# frozen_string_literal: true

module ChitChat
  # Policy to determine if account can view other accounts
  class EventAccountScope
    def initialize(account, event)
      @account = account
      @event = event
    end

    def viewable
      policy = EventPolicy.new(@account, @event)

      [] unless policy.can_view_accounts?

      all_accounts(@event)
    end

    private

    def all_accounts(event)
      [event.organizer] + event.co_organizers + event.participants
    end
  end
end
