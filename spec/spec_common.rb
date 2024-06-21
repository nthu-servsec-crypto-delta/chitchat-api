# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'json'
require 'yaml'

require_relative 'app_test_loader'

def wipe_database # rubocop:disable Metrics/AbcSize
  # Remove table with foreign constraints first
  app.DB.tables.sort_by { |table| -app.DB.foreign_key_list(table).length }.each do |table|
    app.DB[table].delete
  end

  # Clear redis cache
  ChitChat::Cache::Client.new(ChitChat::Api.config).wipe
end

def authenticate(account_data)
  ChitChat::AuthenticateAccount.call(
    username: account_data['username'],
    password: account_data['password']
  )
end

def auth_header(account_data)
  auth = authenticate(account_data)
  "Bearer #{auth[:attributes][:auth_token]}"
end

def authorization(account_data)
  auth = authenticate(account_data)

  token = AuthToken.new(auth[:attributes][:auth_token])
  account = token.payload['attributes']
  {
    account: ChitChat::Account.first(username: account['username']),
    scope: AuthScope.new(token.scope)
  }
end

DIR = 'app/db/seeds'
DATA = {
  accounts: YAML.load_file("#{DIR}/accounts_seed.yml"),
  postits: YAML.load_file("#{DIR}/postits_seed.yml"),
  events: YAML.load_file("#{DIR}/events_seed.yml"),
  co_organizers: YAML.load_file("#{DIR}/co_organizers_seed.yml"),
  participants: YAML.load_file("#{DIR}/participants_seed.yml"),
  applicants: YAML.load_file("#{DIR}/applicants_seed.yml")
}.freeze

BAD_ACCOUNT = {
  'username' => 'bad_account',
  'email' => 'bad@nthu.edu.tw',
  'password' => 'mypa$$w0rd',
  'created_at' => '1900-01-01'
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
