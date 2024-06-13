# frozen_string_literal: true

module ChitChat
  # Methods for controllers to mixin
  module SecureRequest
    def secure_request?(routing)
      routing.scheme.casecmp(Api.config.SECURE_SCHEME).zero?
    end

    def authorization(headers)
      return nil unless headers['AUTHORIZATION']

      scheme, auth_token = headers['AUTHORIZATION'].split
      return nil unless scheme.match?(/^Bearer$/i)

      scoped_auth(auth_token)
    end

    def scoped_auth(auth_token)
      token = AuthToken.new(auth_token)
      account_data = token.payload['attributes']

      { account: Account.first(username: account_data['username']),
        scope: AuthScope.new(token.scope) }
    end
  end
end
