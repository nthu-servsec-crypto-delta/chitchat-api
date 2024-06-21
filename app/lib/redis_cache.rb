# frozen_string_literal: true

require 'redis'

# Redis Cache
class RedisCache
  def self.setup(config)
    @redis = Redis.new(url: config.REDIS_URL)
  end

  def self.keys
    @redis.keys
  end

  def self.wipe
    keys.each { |key| del(key) }
  end

  def self.set(key, value)
    @redis.set(key, value)
  end

  def self.get(key)
    @redis.get(key)
  end

  def self.del(key)
    @redis.del(key)
  end
end
