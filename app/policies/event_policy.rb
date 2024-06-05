# frozen_string_literal: true

module ChitChat
  # Policy to determine if an account can view a particular project
  class EventPolicy
    def initialize(account, event)
      @account = account
      @event = event
    end

    def can_view?
      account_is_organizer? || account_is_co_organizer? || account_is_approved_participant?
    end

    def can_edit?
      account_is_organizer? || account_is_co_organizer?
    end

    def can_delete?
      account_is_organizer?
    end

    def can_leave?
      account_is_co_organizer? || account_is_approved_participant?
    end

    def can_add_co_organizers?
      account_is_organizer?
    end

    def can_remove_co_organizers?
      account_is_organizer?
    end

    def can_approve_participants?
      account_is_organizer? || account_is_co_organizer?
    end

    def can_co_organize?
      !(account_is_organizer? || account_is_co_organizer?)
    end

    def summary
      {
        can_view: can_view?,
        can_edit: can_edit?,
        can_delete: can_delete?,
        can_leave: can_leave?,
        can_add_co_organizers: can_add_co_organizers?,
        can_remove_co_organizers: can_remove_co_organizers?,
        can_approve_participants: can_approve_participants?,
        can_co_organize: can_co_organize?
      }
    end

    private

    def account_is_organizer?
      @event.organizer == @account
    end

    def account_is_co_organizer?
      @event.co_organizers.include?(@account)
    end

    def account_is_participant?
      @event.participants.include?(@account)
    end

    def account_is_approved_participant?
      account_is_participant? && Participation.find(account_id: @account.id, event_id: @event.id).approved
    end

    def account_is_pending_participant?
      account_is_participant? && !Participation.find(account_id: @account.id, event_id: @event.id).approved
    end
  end
end
