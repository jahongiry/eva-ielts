# config/environments/production.rb
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application's code making it resident in memory. This can decrease
  # response time but increases memory consumption.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  config.require_master_key = true

  # Specifies the server port that Rails will listen on; default is 3000.
  config.server_port = ENV.fetch("PORT", 3000)

  # Allow the hostname for the deployed application
  config.hosts << "web-production-71d1d.up.railway.app"

  # Rest of the configuration...
end
