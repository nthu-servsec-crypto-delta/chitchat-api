# frozen_string_literal: true

module ChitChat
  # determine if an account
  class AccountPolicy
    def initialize(requestor, account)
      @requestor = requestor
      @this_account = account
    end

    def can_view?
      self_request? || in_same_event?
    end

    def can_edit?
      self_request?
    end

    def can_delete?
      self_request?
    end

    def summary
      {
        can_view: can_view?,
        can_edit: can_edit?,
        can_delete: can_delete?
      }
    end

    private

    def self_request?
      @requestor == @this_account
    end

    def in_same_event?
      account_events(@requestor).any? do |event|
        event.organizer == @this_account ||
          event.co_organizers.include?(@this_account) ||
          event.participants.include?(@this_account)
      end
    end

    def account_events(account)
      account.owned_events + account.co_organized_events + account.participated_events
    end
  end
end
