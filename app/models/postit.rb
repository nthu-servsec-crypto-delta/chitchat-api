# frozen_string_literal: true

require 'json'
require 'base64'
require 'rbnacl'

module ChitChat
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
      to_h.to_json
    end

    def to_h
      {
        id: @id,
        longitude: @longitude,
        latitude: @latitude,
        message: @message,
        created_at: @created_at
      }
    end

    # Stores postit in file store
    def save
      File.write("#{Api.STORE_DIR}/#{id}.txt", to_json)
    end

    # Query method to find one postit
    def self.find(find_id)
      postit_file = File.read("#{Api::STORE_DIR}/#{find_id}.txt")
      Postit.new(JSON.parse(postit_file))
    end

    def self.all
      Dir.glob("#{Api::STORE_DIR}/*.txt").map do |file|
        file.match(%r{#{Regexp.quote(Api::STORE_DIR)}/(.*)\.txt})[1]
      end
    end

    def new_id
      timestamp = Time.now.to_f.to_s
      Base64.urlsafe_encode64(RbNaCl::Hash.sha256(timestamp))[0..9]
    end
  end
end
