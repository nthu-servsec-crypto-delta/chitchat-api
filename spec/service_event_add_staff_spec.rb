# frozen_string_literal: true

require_relative 'spec_common'

describe 'Test AddStaffToEvent Service' do
  before do
    wipe_database

    ACCOUNTS_DATA.each do |account|
      ChitChat::Account.create(account)
    end

    event_data = EVENTS_DATA[0]

    @organizer = ChitChat::Account.all[0]
    @staff = ChitChat::Account.all[1]

    @event = ChitChat::CreateEventWithOrganizer.call(
      organizer_username: @organizer.username, event_data:
    )
  end

  it 'HAPPY: should be able to add staff to event' do
    ChitChat::AddStaffToEvent.call(
      event_id: @event.id, staff_username: @staff.username
    )

    _(@event.accounts.include?(@staff)).must_equal true
    # _(app.DB[:accounts_events].where(event_id: @event.id, account_id: @staff.id).first[:role]).must_equal 'staff'
  end
end
