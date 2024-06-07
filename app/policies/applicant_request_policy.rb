# frozen_string_literal: true

module ChitChat
  # Policy to determine if a user can invite or remove a co-organizer
  class ApplicantRequestPolicy
    def initialize(event, requestor_account)
      @event = event
      @requestor_account = requestor_account
      @requestor = EventPolicy.new(requestor_account, event)
    end

    def can_apply?
      @requestor.can_apply?
    end

    def can_cancel?
      @requestor.can_cancel?
    end
  end
end
