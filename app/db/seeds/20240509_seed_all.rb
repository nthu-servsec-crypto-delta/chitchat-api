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
PARTICIPANTS_INFO = YAML.load_file("#{DIR}/accounts_events.yml")

def create_accounts
  ACCOUNTS_INFO.each do |account_info|
    ChitChat::Account.create(account_info)
  end
end

def create_owned_postits
  POSTITS_INFO.each do |postit|
    account = ChitChat::Account.first(username: postit['username'])
    postit.delete('username')
    p = ChitChat::Postit.create(postit)
    account.add_owned_postit(p)
  end
end

def create_events
  EVENTS_INFO.each do |event|
    ChitChat::Event.create(event)
  end
end

def add_participants
  PARTICIPANTS_INFO.each do |participant|
    account = ChitChat::Account.first(username: participant['username'])
    event = ChitChat::Event.first(name: participant['eventname'])
    # account.add_event(event, role: participant['role'])
  end
end
