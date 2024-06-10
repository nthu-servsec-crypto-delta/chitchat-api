# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test AddPostits Service' do
  before do
    wipe_database

    @organizer = ChitChat::Account.create(DATA[:accounts][0])
    @random_account = ChitChat::Account.create(DATA[:accounts][1])
    ChitChat::CreateEventForOrganizer.call(
      organizer_id: @organizer.id,
      event_data: DATA[:events][0]
    )
    @event = ChitChat::Event.find(name: DATA[:events][0]['name'])
  end

  it 'HAPPY: should be able to create postit if in event' do
    ChitChat::CreatePostitForEvent.call(
      account: @organizer,
      event: @event,
      postit_data: DATA[:postits][0]
    )
    _(@event.postits.size).must_equal 1
    _(@organizer.owned_postits.size).must_equal 1
  end

  it 'SAD: should not be able to create postit if account not in event' do
    _(proc {
      ChitChat::CreatePostitForEvent.call(
        account: @random_account,
        event: @event,
        postit_data: DATA[:postits][0]
      )
    }).must_raise ChitChat::CreatePostitForEvent::ForbiddenError
  end
end
