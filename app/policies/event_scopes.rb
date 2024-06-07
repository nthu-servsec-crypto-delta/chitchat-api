# frozen_string_literal: true

module ChitChat
  # Policy to determine if account can view a event
  class EventPolicy
    # Scope of event policies
    class AccountScope
      def initialize(account)
        @account = account
      end

      def all
        Event.all
      end

      def with_roles
        all.select do |event|
          includes_role?(event, @account)
        end
      end

      private

      def includes_role?(event, account)
        event.organizer == account ||
          event.co_organizers.include?(account) ||
          event.participants.include?(account)
      end
    end
  end
end
