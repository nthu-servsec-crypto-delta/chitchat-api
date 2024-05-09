# frozen_string_literal: true

module ChitChat
  # Create new event with organizer
  class CreateEventWithOrganizer
    def self.call(organizer_username:, event_data:)
      organizer = Account.first(username: organizer_username)
      event = Event.create(event_data)

      event.add_account(organizer)

      # update role column
      # row = app.DB[:accounts_events].where(event_id: event.id, account_id: organizer.id).first
      # row[:role] = 'organizer'
      event
    end
  end
end
