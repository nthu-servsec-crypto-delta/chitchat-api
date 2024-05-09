# frozen_string_literal: true

require 'rake/testtask'
require './require_app'

task :default do
  puts `rake -T`
end

desc 'debug console'
task :console do
  sh 'pry -r ./spec/app_test_loader.rb'
end

desc 'Tests API specs only'
task :api_spec do
  sh 'ruby spec/api_spec.rb'
end

desc 'Tests Account specs only'
task :api_account_spec do
  sh 'ruby spec/api_accounts_spec.rb'
end

desc 'Tests Postit specs only'
task :postit_spec do
  sh 'ruby spec/postits_spec.rb'
end

desc 'Tests Event specs only'
task :event_spec do
  sh 'ruby spec/events_spec.rb'
end

desc 'Tests Environment specs only'
task :env_spec do
  sh 'ruby spec/env_spec.rb'
end

desc 'Tests SecureDB specs only'
task :secure_db_spec do
  sh 'ruby spec/secure_db_spec.rb'
end

desc 'Tests PasswordDigest specs only'
task :password_digest_spec do
  sh 'ruby spec/password_digest_spec.rb'
end

desc 'Test all the specs'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

desc 'Runs rubocop on tested code'
task :style => [:spec, :audit] do
  sh 'rubocop . --parallel'
end

desc 'Update vulnerabilities lit and audit gems'
task :audit do
  sh 'bundle audit check --update'
end

desc 'Checks for release'
task :release? => [:spec, :style, :audit] do
  puts "\nReady for release!"
end

task :print_env do
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
end

namespace :db do
  task :load do
    require_app(nil) # load nothing by default
    require 'sequel'

    Sequel.extension :migration
    @app = ChitChat::Api
  end

  task :load_models do
    require_app('models')
  end

  desc 'Run migrations'
  task :migrate => [:load, :print_env] do
    puts 'Migrating database to latest'
    Sequel::Migrator.run(@app.DB, 'app/db/migrations')
  end

  desc 'Destroy data in database; maintain tables'
  task :delete => :load_models do
    ChitChat::Postit.dataset.destroy
  end

  desc 'Delete dev or test database file'
  task :drop => :load do
    if @app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end

    db_filename = "app/db/store/#{ChitChat::Api.environment}.db"
    FileUtils.rm(db_filename)
    puts "Deleted #{db_filename}"
  end
end

# Add a new key named DB_KEY in secrets.yml before running this task or an error caused by require_app will occur
# Reason of the error:
# Rakefile -> require_app -> require('config') -> require environments ->
# SecureDB.setup(ENV.delete('DB_KEY')) -> cannot find DB_KEY environment variable
namespace :newkey do
  desc 'Create sample cryptographic key for database'
  task :db do
    require_app('lib')
    puts "DB_KEY: #{SecureDB.generate_key}"
  end
end
