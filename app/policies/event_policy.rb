# frozen_string_literal: true

module ChitChat
  # Policy to determine if an account can view a particular project
  class EventPolicy
    def initialize(account, event, auth_scope = nil)
      @account = account
      @event = event
      @auth_scope = auth_scope
    end

    def can_view?
      true
    end

    def can_edit?
      can_write? && (account_is_organizer? || account_is_co_organizer?)
    end

    def can_delete?
      can_write? && account_is_organizer?
    end

    def can_leave?
      can_write? && (account_is_co_organizer? || account_is_participant?)
    end

    def can_view_accounts?
      can_read? && (account_is_organizer? || account_is_co_organizer? || account_is_participant?)
    end

    def can_create_postit?
      can_write? && (account_is_organizer? || account_is_co_organizer? || account_is_participant?)
    end

    def can_view_postits?
      can_read? && (account_is_organizer? || account_is_co_organizer? || account_is_participant?)
    end

    def can_add_co_organizers?
      can_write? && account_is_organizer?
    end

    def can_remove_co_organizers?
      can_write? && account_is_organizer?
    end

    def can_approve_applicants?
      can_write? && (account_is_organizer? || account_is_co_organizer?)
    end

    def can_reject_applicants?
      can_write? && (account_is_organizer? || account_is_co_organizer?)
    end

    def can_participate?
      can_write? &&
        account_is_applicant? &&
        !(account_is_organizer? || account_is_co_organizer? || account_is_participant?)
    end

    def can_apply?
      can_write? &&
        (!account_is_organizer? && !account_is_co_organizer? && !account_is_participant? && !account_is_applicant?)
    end

    def can_cancel?
      can_write? && account_is_applicant?
    end

    def can_co_organize?
      can_write? && !(account_is_organizer? || account_is_co_organizer?)
    end

    def can_read?
      @auth_scope ? @auth_scope.can_read?('events') : false
    end

    def can_write?
      @auth_scope ? @auth_scope.can_write?('events') : false
    end

    def summary # rubocop:disable Metrics/MethodLength
      {
        can_view: can_view?,
        can_edit: can_edit?,
        can_delete: can_delete?,
        can_leave: can_leave?,
        can_add_co_organizers: can_add_co_organizers?,
        can_remove_co_organizers: can_remove_co_organizers?,
        can_approve_applicants: can_approve_applicants?,
        can_reject_applicants: can_reject_applicants?,
        can_apply: can_apply?,
        can_cancel: can_cancel?
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

    def account_is_applicant?
      @event.applicants.include?(@account)
    end
  end
end
