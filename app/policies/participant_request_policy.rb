# frozen_string_literal: true

module ChitChat
  # Policy to determine if a user can invite or remove a co-organizer
  class ParticipantRequestPolicy
    def initialize(event, requestor_account, target_account, auth_scope = nil)
      @event = event
      @auth_scope = auth_scope
      @requestor_account = requestor_account
      @target_account = target_account
      @requestor = EventPolicy.new(requestor_account, event, auth_scope)
      @target = EventPolicy.new(target_account, event, auth_scope)
    end

    # If account is organizer/co-organizer, this is an approval request
    # If account is participant or none, raise ForbiddenError

    def can_approve?
      can_write? && @requestor.can_approve_applicants? && @target.can_participate?
    end

    def can_remove?
      can_write? && @requestor.can_remove_co_organizers? && target_is_participant?
    end

    # If account is participant of current_event, this is a leave request
    def can_leave?
      can_write? && @requestor.can_leave? && target_is_participant?
    end

    def can_write?
      @auth_scope ? @auth_scope.can_write?('events') : false
    end

    private

    def target_is_participant?
      @event.participants.include?(@target_account)
    end
  end
end
