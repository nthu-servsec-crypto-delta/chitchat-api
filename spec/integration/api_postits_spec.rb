# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test postits API' do
  before do
    wipe_database

    DATA[:postits].each do |postit_data|
      ChitChat::Postit.create(postit_data)
    end
  end

  describe 'Getting list of postits' do
    before do
      @account_data = DATA[:accounts][0]
      account = ChitChat::Account.create(@account_data)
      account.add_owned_postit(DATA[:postits][0])
      account.add_owned_postit(DATA[:postits][1])
    end

    it 'HAPPY: should get list for authorized account' do
      auth = ChitChat::AuthenticateAccount.call(
        username: @account_data['username'],
        password: @account_data['password']
      )
      header 'AUTHORIZATION', "Bearer #{auth[:attributes][:auth_token]}"
      get 'api/v1/postits'
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['data'].count).must_equal 2
    end

    it 'BAD: should not process for unauthorized account' do
      header 'AUTHORIZATION', 'Bearer bad_token'
      get 'api/v1/postits'
      _(last_response.status).must_equal 403

      result = JSON.parse last_response.body
      _(result['data']).must_be_nil
    end
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

  it 'SECURITY: should return error if there is Mass Assignment attempt' do
    payload = MASS_ASSIGNMENT_POSTIT
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    post 'api/v1/postits', payload.to_json, req_header

    _(last_response.status).must_equal 400
  end

  it 'SECURITY: should prevent SQL injection' do
    get '/api/v1/postits/1%20or%201%3D1'

    _(last_response.status).must_equal 404
  end

  it 'HAPPY: should be able to create new postits' do
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    post 'api/v1/postits', DATA[:postits][1].to_json, req_header

    _(last_response.status).must_equal 201
  end
end
