# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web API
gem 'json'
gem 'puma', '~>6.1'
gem 'roda', '~>3.1'

gem 'http'

# Configuration
gem 'figaro', '~>1.2'
gem 'rake'

# Security
gem 'bundler-audit'
gem 'rbnacl', '~>7.1'

# Database
gem 'hirb'
gem 'sequel', '~>5.55'
group :development, :test do
  gem 'sequel-seed'
  gem 'sqlite3', '~>1.4'
end

group :production do
  gem 'pg'
end

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack-test'
end

# Debugging
group :development do
  gem 'pry'
  gem 'rerun'
end

# Quality
group :rubocop do
  gem 'rubocop'
  gem 'rubocop-performance'
end
