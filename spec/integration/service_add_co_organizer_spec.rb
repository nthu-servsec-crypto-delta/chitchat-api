# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test AddCoOrganizer Service' do
  before do
    wipe_database

    @organizer = ChitChat::Account.create(DATA[:accounts][0])
    @co_organizer = ChitChat::Account.create(DATA[:accounts][1])
    @event = ChitChat::Event.create(DATA[:events][0])
    @organizer.add_owned_event(@event)
  end

  it 'HAPPY: should be able to add co-organizer to event' do
    ChitChat::AddCoOrganizer.call(
      event: @event,
      account: @organizer,
      co_organizer_email: @co_organizer.email
    )
    _(@event.co_organizers.include?(@co_organizer)).must_equal true
  end
end
