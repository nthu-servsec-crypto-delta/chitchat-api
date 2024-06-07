# frozen_string_literal: true

module ChitChat
  # Delete event
  class DeleteEvent
    class ForbiddenError < StandardError; end

    def self.call(account:, event:)
      policy = EventPolicy.new(account, event)

      raise ForbiddenError, 'You are not allowed to delete that event' unless policy.can_delete?

      event.destroy
    end
  end
end
