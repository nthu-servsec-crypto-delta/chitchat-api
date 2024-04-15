# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'yaml'

require_relative '../app/controllers/app'

def app
  LocationApi::App
end

describe 'Location API test' do
  include Rack::Test::Methods

  it 'root should work' do
    get '/'
    _(last_response.status).must_equal 200
    _(last_response.body).must_include 'It works!'
  end
end
