require 'redis'
require 'redis-namespace'
require 'redis/objects'

$redis = Redis.new(host: ENV["REDIS_HOST"], port: ENV["REDIS_PORT"])
$redis.select(0)
Redis::Objects.redis = $redis

sidekiq_url = "redis://#{ENV["REDIS_HOST"]}:#{ENV["REDIS_PORT"]}/0"
Sidekiq.configure_server do |config|
  config.redis = { namespace: 'sidekiq', url: sidekiq_url }
end
Sidekiq.configure_client do |config|
  config.redis = { namespace: 'sidekiq', url: sidekiq_url }
end