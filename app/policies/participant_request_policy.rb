# frozen_string_literal: true

module ChitChat
  # Policy to determine if a user can invite or remove a co-organizer
  class ParticipantRequestPolicy
    def initialize(event, requestor_account, target_account)
      @event = event
      @requestor_account = requestor_account
      @target_account = target_account
      @requestor = EventPolicy.new(requestor_account, event)
      @target = EventPolicy.new(target_account, event)
    end

    # If account is organizer/co-organizer, this is an approval request
    # If account is participant or none, raise ForbiddenError

    def can_approve?
      @requestor.can_approve_applicants? && @target.can_participate?
    end

    def can_remove?
      @requestor.can_remove_co_organizers? && target_is_participant?
    end

    private

    def target_is_participant?
      @event.participant.include?(@target_account)
    end
  end
end
