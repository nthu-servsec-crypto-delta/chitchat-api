# frozen_string_literal: true

require_relative '../lib/key_stretch'

module ChitChat
  # Password Digest
  class PasswordDigest
    extend KeyStretch

    # salt is already included in the digest, don't need to store it
    def initialize(password_digest)
      @digest = password_digest
    end

    def correct?(password)
      PasswordDigest.valid?(password, @digest)
    end

    def self.digest(password)
      PasswordDigest.hash_password(password).to_s
    end

    def self.from_digest(password_digest)
      new(password_digest)
    end
  end
end
