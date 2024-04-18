# frozen_string_literal: true

require 'json'
require 'base64'
require 'rbnacl'

module ChitChat
  STORE_DIR = 'app/db/store'

  # User Location Model
  class Postit
    def initialize(new_postit)
      @id = new_postit['id'] || new_id
      @created_at = new_postit['created_at'] || Time.now
      @longitude = new_postit['longitude']
      @latitude = new_postit['latitude']
      @message = new_postit['message']
    end

    attr_reader :id, :longitude, :latitude, :message, :created_at

    def to_json(_options = {})
      {
        id: @id,
        longitude: @longitude,
        latitude: @latitude,
        message: @message,
        created_at: @created_at
      }.to_json
    end

    # File store must be setup once when application runs
    def self.setup
      FileUtils.mkdir_p(ChitChat::STORE_DIR)
    end

    # Stores postit in file store
    def save
      File.write("#{ChitChat::STORE_DIR}/#{id}.txt", to_json)
    end

    # Query method to find one postit
    def self.find(find_id)
      postit_file = File.read("#{ChitChat::STORE_DIR}/#{find_id}.txt")
      Postit.new(JSON.parse(postit_file))
    end

    def self.all
      Dir.glob("#{ChitChat::STORE_DIR}/*.txt").map do |file|
        file.match(%r{#{Regexp.quote(ChitChat::STORE_DIR)}/(.*)\.txt})[1]
      end
    end

    def new_id
      timestamp = Time.now.to_f.to_s
      Base64.urlsafe_encode64(RbNaCl::Hash.sha256(timestamp))[0..9]
    end
  end
end
