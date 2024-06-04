# frozen_string_literal: true

module ChitChat
  # Policy to determine if a user can invite or remove a co-organizer
  class CoOrganizerRequestPolicy
    def initialize(event, requestor_account, target_account)
      @event = event
      @requestor_account = requestor_account
      @target_account = target_account
      @requestor = EventPolicy.new(requestor_account, event)
      @target = EventPolicy.new(target_account, event)
    end

    def can_invite?
      @requestor.can_add_co_organizers? && @target.can_co_organize?
    end

    def can_remove?
      @requestor.can_remove_co_organizers? && target_is_co_organizer?
    end

    private

    def target_is_co_organizer?
      @project.co_organizer.include?(@target_account)
    end
  end
end
