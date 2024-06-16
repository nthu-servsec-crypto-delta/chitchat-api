# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test AddPostits Service' do
  before do
    wipe_database
    @organizer_data = DATA[:accounts][0]
    @organizer = ChitChat::Account.create(@organizer_data)

    @account_data = DATA[:accounts][1]
    @account = ChitChat::Account.create(@account_data)

    @event = ChitChat::Event.create(DATA[:events][0])
    @organizer.add_owned_event(@event)
  end

  it 'HAPPY: should be able to create postit if in event' do
    auth = authorization(@organizer_data)
    @organizer.location = @event.location
    ChitChat::CreatePostitForEvent.call(
      event: @event,
      auth:,
      postit_data: DATA[:postits][0]
    )
    _(@event.postits.size).must_equal 1
    _(@organizer.owned_postits.size).must_equal 1
  end

  it 'SAD: should not be able to create postit if account not in event' do
    auth = authorization(@account_data)
    _(proc {
      ChitChat::CreatePostitForEvent.call(
        event: @event,
        auth:,
        postit_data: DATA[:postits][0]
      )
    }).must_raise ChitChat::CreatePostitForEvent::ForbiddenError
  end
end
