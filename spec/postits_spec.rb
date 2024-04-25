# frozen_string_literal: true

require_relative 'spec_common'

describe 'Test postits API' do
  before do
    wipe_database

    POSTITS_DATA.each do |postit_data|
      ChitChat::Postit.create(postit_data)
    end
  end

  it 'HAPPY: should be able to get list of all postits' do
    get '/api/v1/postits'
    _(last_response.status).must_equal 200

    result = JSON.parse(last_response.body)
    _(result['postit_ids'].count).must_equal 2
  end

  it 'HAPPY: should be able to get details of a single postit' do
    postit = ChitChat::Postit.first
    get "/api/v1/postits/#{postit.id}"
    result = JSON.parse last_response.body

    _(last_response.status).must_equal 200
    _(result['id']).must_equal postit.id
  end

  it 'SAD: should return error if unknown postit requested' do
    get '/api/v1/postits/foobar'

    _(last_response.status).must_equal 404
  end

  it 'HAPPY: should be able to create new postits' do
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    post 'api/v1/postits', POSTITS_DATA[1].to_json, req_header

    _(last_response.status).must_equal 201
  end
end
