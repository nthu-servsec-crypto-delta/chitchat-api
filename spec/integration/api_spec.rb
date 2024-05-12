# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test ChitChat Web API' do
  it 'root should work' do
    get '/'
    _(last_response.status).must_equal 200
    _(last_response.body).must_include 'ChitChatAPI up at /api/v1'
  end

  it 'should not work if https is used, http is used in dev and test' do
    get '/path', {}, 'rack.url_scheme' => 'https'
    _(last_response.status).must_equal 403
    _(last_response.body).must_include 'TLS/SSL Required'
  end
end
