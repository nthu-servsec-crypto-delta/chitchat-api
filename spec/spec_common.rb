# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'json'
require 'yaml'

require_relative 'app_test_loader'

def wipe_database
  # Remove table with foreign constraints first
  ChitChat::Participation.map(&:destroy)
  ChitChat::Postit.map(&:destroy)
  ChitChat::Event.map(&:destroy)
  ChitChat::Account.map(&:destroy)
end

DATA = {
  accounts: YAML.safe_load_file('app/db/seeds/accounts_seed.yml'),
  postits: YAML.safe_load_file('app/db/seeds/postits_seed.yml'),
  events: YAML.safe_load_file('app/db/seeds/events_seed.yml'),
  participations: YAML.safe_load_file('app/db/seeds/participations_seed.yml')
}.freeze

MASS_ASSIGNMENT_POSTIT = {
  'id' => 500,
  'location' => { 'latitude' => 0.0, 'longitude' => 0.0 },
  'message' => 'Mass Assignment Attempt'
}.freeze

MASS_ASSIGNMENT_EVENT = {
  'id' => 500,
  'location' => { 'latitude' => 0.0, 'longitude' => 0.0 },
  'name' => 'Mass Assignment',
  'description' => 'Mass Assignment Attempt',
  'created_at' => '2020-01-01 12:00:00'
}.freeze
