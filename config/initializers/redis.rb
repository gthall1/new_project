uri = URI.parse(ENV["REDISCLOUD_URL"] || "redis://localhost:6379/")
if !Rails.env.development?
    $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
    $redis = Redis.new(:host => uri.host, :port => uri.port)
end
