# frozen_string_literal: true

require 'rbnacl'

# Key Stretching Password Hash using Argon2
module KeyStretch
  def hash_password(password)
    opslimit = 10
    memlimit = 2**24
    digest_size = 64

    hasher = RbNaCl::PasswordHash::Argon2.new(opslimit, memlimit, digest_size)

    # salt is included in the digest
    hasher.digest_str(password)
  end

  def valid?(password, digest)
    RbNaCl::PasswordHash::Argon2.digest_str_verify(password, digest)
  end
end
