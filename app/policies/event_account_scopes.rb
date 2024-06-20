# frozen_string_literal: true

module ChitChat
  # Policy to determine if account can view other accounts
  class EventAccountScope
    def initialize(account, event, auth_scope = nil)
      @account = account
      @event = event
      @auth_scope = auth_scope
    end

    def viewable
      policy = EventPolicy.new(@account, @event, @auth_scope)
      policy.can_view_accounts? ? account_in_range(@event) : []
    end

    private

    def account_in_range(event)
      accounts = all_accounts(event)
      accounts.select do |account|
        account_has_location?(account) &&
          event.location.distance_to(account.location) < event.radius
      end
    end

    def all_accounts(event)
      [event.organizer] + event.co_organizers + event.participants
    end

    def account_has_location?(account)
      !account.location.nil?
    end
  end
end
