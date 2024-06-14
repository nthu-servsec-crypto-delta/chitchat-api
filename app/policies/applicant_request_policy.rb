# frozen_string_literal: true

module ChitChat
  # Policy to determine if a user can invite or remove a co-organizer
  class ApplicantRequestPolicy
    def initialize(event, requestor_account, auth_scope = nil)
      @event = event
      @requestor_account = requestor_account
      @auth_scope = auth_scope
      @requestor = EventPolicy.new(requestor_account, event, auth_scope)
    end

    def can_apply?
      can_write? && @requestor.can_apply?
    end

    def can_cancel?
      can_write? && @requestor.can_cancel?
    end

    def can_write?
      @auth_scope ? @auth_scope.can_write?('events') : false
    end
  end
end
