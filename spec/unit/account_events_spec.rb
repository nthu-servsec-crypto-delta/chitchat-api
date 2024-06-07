# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test participation adding' do
  before do
    wipe_database

    DATA[:accounts].each do |account|
      ChitChat::Account.create(account)
    end

    DATA[:events].each do |event|
      ChitChat::Event.create(event)
    end
  end

  it 'HAPPY: should be able to add participations' do
    account = ChitChat::Account.first
    event = ChitChat::Event.first

    event.add_participant(account)
    _(event.participants.include?(account)).must_equal true
  end

  it 'HAPPY: should be able to add co-organizers' do
    account = ChitChat::Account.first
    event = ChitChat::Event.first

    event.add_co_organizer(account)
    _(event.co_organizers.include?(account)).must_equal true
  end

  it 'HAPPY: should be able to add organizer' do
    account = ChitChat::Account.first
    event = ChitChat::Event.first
    account.add_owned_event(event)
  end
end
