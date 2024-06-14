# frozen_string_literal: true

module ChitChat
  # Policy to determine if a user can invite or remove a co-organizer
  class CoOrganizerRequestPolicy
    def initialize(event, requestor_account, target_account, auth_scope = nil)
      @event = event
      @auth_scope = auth_scope
      @requestor_account = requestor_account
      @target_account = target_account
      @requestor = EventPolicy.new(requestor_account, event, auth_scope)
      @target = EventPolicy.new(target_account, event, auth_scope)
    end

    def can_invite?
      can_write? && @requestor.can_add_co_organizers? && @target.can_co_organize?
    end

    def can_remove?
      can_write? && @requestor.can_remove_co_organizers? && target_is_co_organizer?
    end

    def can_write?
      @auth_scope ? @auth_scope.can_write?('events') : false
    end

    private

    def target_is_co_organizer?
      @event.co_organizers.include?(@target_account)
    end
  end
end
