require 'redis'
require 'redis-namespace'
require 'redis/objects'

$redis = Redis.new(host: A.redis.host, port: A.redis.port)
$redis.select(0)
Redis::Objects.redis = $redis

sidekiq_url = "redis://#{A.redis.host}:#{A.redis.port}/0"
Sidekiq.configure_server do |config|
  config.redis = { namespace: 'sidekiq', url: sidekiq_url }
end
Sidekiq.configure_client do |config|
  config.redis = { namespace: 'sidekiq', url: sidekiq_url }
end