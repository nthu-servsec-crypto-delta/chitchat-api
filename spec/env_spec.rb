# frozen_string_literal: true

require_relative 'spec_common'

describe 'Check secret env variables' do
  it 'SAD: DATABASE_URL env should be deleted after DB loaded' do
    _(ENV.fetch('DATABASE_URL', nil)).must_be_nil
  end
end
