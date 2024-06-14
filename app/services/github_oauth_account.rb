# frozen_string_literal: true

module ChitChat
  # Authorize account with GitHub OAuth
  class GitHubOAuthAccount
    # Error for invalid code or access token
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
    end

    def oauth(code)
      response = HTTP.post(
        'https://github.com/login/oauth/access_token',
        json: { client_id: @config.GITHUB_OAUTH_CLIENT_ID, client_secret: @config.GITHUB_OAUTH_CLIENT_SECRET, code: },
        headers: { 'Accept' => 'application/json' }
      )

      raise UnauthorizedError, "OAuth: #{response.parse['error_description']}" unless response.code == 200
      raise UnauthorizedError, 'OAuth: No Email Scope' unless response.parse['scope'].split(',').include?('user:email')

      response.parse['access_token']
    end

    def fetch_account(access_token)
      response = HTTP.auth("token #{access_token}").get('https://api.github.com/user')
      raise UnauthorizedError, "GitHub Account: #{response.parse['message']}" unless response.code == 200

      github_account = GitHubAccount.new(response.parse)
      fetch_account_email(access_token, github_account)
    end

    def fetch_account_email(access_token, github_account)
      return github_account unless github_account.email.nil?

      response = HTTP.auth("token #{access_token}").get('https://api.github.com/user/emails')
      raise UnauthorizedError, "GitHub Account Email: #{response.parse['message']}" unless response.code == 200

      github_account_email = response.parse.find { |email| email['primary'] }['email']
      github_account.email = github_account_email
      github_account
    end

    def create_account_if_missing(github_account)
      account = Account.first(email: github_account.email)
      return account if account

      Account.create(github_account.to_h)
    end

    def call(code)
      access_token = oauth(code)
      github_account = fetch_account(access_token)
      account = create_account_if_missing(github_account)

      account_and_token(account)
    end

    def account_and_token(account)
      {
        type: 'sso_account',
        attributes: {
          account:,
          auth_token: AuthToken.create(account)
        }
      }
    end
  end
end
