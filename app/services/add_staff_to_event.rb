# frozen_string_literal: true

module ChitChat
  # Create new configuration for a project
  class AddStaffToEvent
    def self.call(event_id:, staff_username:)
      event = Event.first(id: event_id)
      staff = Account.first(username: staff_username)

      event.add_account(staff)

      # update role column
      # row = app.DB[:accounts_events].where(event_id:, account_id: staff.id).first
      # row[:role] = 'staff'
    end
  end
end
