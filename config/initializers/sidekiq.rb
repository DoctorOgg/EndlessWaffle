require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  User.authenticate(user,password)
end

redis_url = URI.parse(URI::extract(REDIS.inspect).first).to_s
config_hash = {url: redis_url}

Sidekiq.configure_server do |config|
  config.redis = config_hash
end

Sidekiq.configure_client do |config|
  config.redis = config_hash
end
