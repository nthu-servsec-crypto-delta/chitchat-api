# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test editing and deleting event service' do
  before do
    wipe_database
    @organizer_data = DATA[:accounts][0]
    @organizer = ChitChat::Account.create(@organizer_data)

    @account_data = DATA[:accounts][1]
    @account = ChitChat::Account.create(@account_data)

    @event = ChitChat::Event.create(DATA[:events][0])
    @new_event_data = DATA[:events][1]
    @organizer.add_owned_event(@event)
  end

  it 'HAPPY: should be allowed to edit event' do
    auth = authorization(@organizer_data)

    ChitChat::EditEvent.call(
      event: @event,
      auth:,
      new_event_data: @new_event_data
    )
    _(@event.name).must_equal @new_event_data['name']
    _(@event.description).must_equal @new_event_data['description']
  end

  it 'HAPPY: should be allowed to delete event' do
    auth = authorization(@organizer_data)
    ChitChat::DeleteEvent.call(
      event: @event,
      auth:
    )
    _(ChitChat::Event.find(name: @event.name)).must_be_nil
  end
end
