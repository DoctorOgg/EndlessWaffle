redis = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
uri = URI.parse(redis["url"])
REDIS = Redis.new(url: uri.to_s, port: uri.port).freeze
puts ">> Initialized REDIS with #{REDIS.inspect}"
