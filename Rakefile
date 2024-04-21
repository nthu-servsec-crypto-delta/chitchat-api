# frozen_string_literal: true

require 'rake/testtask'
require './require_app'

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
