# frozen_string_literal: true

module ChitChat
  # Edit an existing event
  class EditEvent
    # Custom error for when a user is not allowed to edit an event
    class ForbiddenError < StandardError
      def message
        'You are not allowed to edit events'
      end
    end

    def self.call(auth:, event:, new_event_data:)
      policy = EventPolicy.new(auth[:account], event, auth[:scope])

      raise ForbiddenError unless policy.can_edit?

      event.update_fields(new_event_data, %w[name description location radius start_time end_time])
    end
  end
end
