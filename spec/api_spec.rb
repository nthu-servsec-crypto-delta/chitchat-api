# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'yaml'

require_relative '../require_app'
require_app

def app
  ChitChat::Api
end

DATA = YAML.safe_load_file('app/db/seeds/postit_seeds.yml')

describe 'Test ChitChat Web API' do
  include Rack::Test::Methods

  before do
    # Wipe database before each test
    Dir.glob("#{ChitChat::Api.STORE_DIR}/*.txt").each { |filename| FileUtils.rm(filename) }
  end

  it 'root should work' do
    get '/'
    _(last_response.status).must_equal 200
    _(last_response.body).must_include 'ChitChatAPI up at /api/v1'
  end

  describe 'Handle postits' do
    it 'HAPPY: should be able to get list of all postits' do
      ChitChat::Postit.new(DATA[0]).save
      ChitChat::Postit.new(DATA[1]).save

      get '/api/v1/postits'
      result = JSON.parse(last_response.body)
      _(result['postit_ids'].count).must_equal 2
    end

    it 'HAPPY: should be able to get details of a single postit' do
      ChitChat::Postit.new(DATA[1]).save
      id = Dir.glob("#{ChitChat::Api.STORE_DIR}/*.txt").first.split(%r{[/.]})[3]

      get "/api/v1/postits/#{id}"
      result = JSON.parse last_response.body

      _(last_response.status).must_equal 200
      _(result['id']).must_equal id
    end

    it 'SAD: should return error if unknown postit requested' do
      get '/api/v1/postits/foobar'

      _(last_response.status).must_equal 404
    end

    it 'HAPPY: should be able to create new postits' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post 'api/v1/postits', DATA[1].to_json, req_header

      _(last_response.status).must_equal 201
    end
  end
end
