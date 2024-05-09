# frozen_string_literal: true

Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, postits and events...'
    create_accounts
    create_owned_postits
    create_events
    add_participants
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yml")
POSTITS_INFO = YAML.load_file("#{DIR}/postits_seed.yml")
EVENTS_INFO = YAML.load_file("#{DIR}/events_seed.yml")
PARTICIPANT_INFO = YAML.load_file("#{DIR}/accounts_events.yml")

def create_accounts
  ACCOUNTS_INFO.each do |account_info|
    ChitChat::Account.create(account_info)
  end
end

def create_owned_postits
  POSTITS_INFO.each do |postit|
    puts postit
    account = ChitChat::Account.first(username: postit['username'])
    # remove username from postit hash
    postit.delete('username')

    # set postit owner to account
    postit['owner_id'] = account.id
    ChitChat::Postit.create(postit)
  end
end

def create_events
  EVENTS_INFO.each do |event|
    account = ChitChat::Account.first(username: event['username'])
    # set event host to account
    event['host_id'] = account.id
    ChitChat::Event.create(event)
  end
end

def add_participants
  PARTICIPANT_INFO.each do |participant|
    # account = ChitChat::Account.first(username: participant['username'])
    # event = ChitChat::Event.first(name: participant['eventname'])
    # participant['participant_id'] = account.id
    # participant['event_id'] = event.id
    # ChitChat::Participant.create(participant)
  end
end
