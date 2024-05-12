# frozen_string_literal: true

require_relative '../spec_common'

describe 'Test ChitChat Web API' do
  it 'root should work' do
    get '/'
    _(last_response.status).must_equal 200
    _(last_response.body).must_include 'ChitChatAPI up at /api/v1'
  end
end
