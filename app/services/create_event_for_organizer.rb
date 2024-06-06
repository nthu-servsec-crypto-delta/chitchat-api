# frozen_string_literal: true

module ChitChat
  # Service object to create a new project for an owner
  class CreateEventForOrganizer
    def self.call(organizer_id:, event_data:)
      Account.find(id: organizer_id)
             .add_owned_event(event_data)
    end
  end
end
