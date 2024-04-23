# frozen_string_literal: true

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
