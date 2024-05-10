# frozen_string_literal: true

require_relative 'spec_common'

describe 'Test PasswordDigest Class' do
  it 'SECURITY: should hash password and hide raw password' do
    password = 'C8763'
    digest = ChitChat::PasswordDigest.digest(password)

    _(digest.match?(password)).must_equal false
  end

  it 'SECURITY: should validate password' do
    password = 'C8763'
    digest = ChitChat::PasswordDigest.digest(password)
    password_digest = ChitChat::PasswordDigest.from_digest(digest)

    _(password_digest.correct?(password)).must_equal true
  end

  it 'SECURITY: should not validate incorrect password' do
    password = 'C8763'
    guess = '48763'
    digest = ChitChat::PasswordDigest.digest(password)
    password_digest = ChitChat::PasswordDigest.from_digest(digest)

    _(password_digest.correct?(guess)).must_equal false
  end
end
