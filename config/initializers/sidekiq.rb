redis_config = Rails.application.config_for(:redis)
redis_config.symbolize_keys!

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/12" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/12" }
end
