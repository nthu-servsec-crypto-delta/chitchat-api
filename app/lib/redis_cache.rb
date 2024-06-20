# frozen_string_literal: true

require 'redis'

module ChitChat
  module Cache
    # Redis client utility
    class Client
      def initialize(config)
        @redis = Redis.new(url: config.REDIS_URL)
      end

      def keys
        @redis.keys
      end

      def wipe
        keys.each { |key| del(key) }
      end

      def set(key, value)
        @redis.set(key, value)
      end

      def get(key)
        @redis.get(key)
      end

      def del(key)
        @redis.del(key)
      end
    end
  end
end
