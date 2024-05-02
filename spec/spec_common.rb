# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'json'
require 'yaml'

require_relative 'app_test_loader'

def wipe_database
  app.DB.tables.each do |table|
    app.DB[table].delete
  end
end

POSTITS_DATA = YAML.safe_load_file('app/db/seeds/postit_seeds.yml')
EVENTS_DATA = YAML.safe_load_file('app/db/seeds/event_seeds.yml')

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
