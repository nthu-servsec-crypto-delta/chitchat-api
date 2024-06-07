# frozen_string_literal: true

module ChitChat
  # Edit an existing event
  class EditEvent
    class ForbiddenError < StandardError; end

    def self.call(account:, event:, new_event_data:)
      policy = EventPolicy.new(account, event)

      raise ForbiddenError, 'You are not allowed to edit that event' unless policy.can_edit?

      event.update_fields(new_event_data, %w[name description location radius start_time end_time])
    end
  end
end
