# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test AddCoOrganizer Service' do
  before do
    wipe_database
    @organizer_data = DATA[:accounts][0]
    @organizer = ChitChat::Account.create(@organizer_data)

    ChitChat::CreateEventForOrganizer.call(
      organizer_id: @organizer.id,
      event_data: DATA[:events][0]
    )
    @account_data = DATA[:accounts][1]
    @account = ChitChat::Account.create(@account_data)
    @event = ChitChat::Event.find(name: DATA[:events][0]['name'])
  end

  it 'HAPPY: should be able to add co-organizer to event' do
    auth = authorization(@organizer_data)
    ChitChat::AddCoOrganizer.call(
      event: @event,
      auth:,
      co_organizer_email: @account.email
    )
    _(@event.co_organizers.include?(@account)).must_equal true
  end

  it 'HAPPY: should be able to remove co-organizer from event' do
    @event.add_co_organizer(@account)

    auth = authorization(@organizer_data)
    ChitChat::RemoveCoOrganizer.call(
      event: @event,
      auth:,
      co_organizer_email: @account.email
    )
    _(@event.co_organizers.include?(@co_organizer)).must_equal false
  end
end
