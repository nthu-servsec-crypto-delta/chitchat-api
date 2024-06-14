# frozen_string_literal: true

module ChitChat
  # GitHub Account
  class GitHubAccount
    attr_accessor :email

    def initialize(github_account)
      @login = github_account['login']
      @email = github_account['email']
    end

    def username
      "#{@login}@github"
    end

    def to_h
      {
        username:,
        email:
      }
    end
  end
end
