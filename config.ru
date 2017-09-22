require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

require 'sidekiq/web'
require 'sidekiq-scheduler/web'
run Sidekiq::Web
