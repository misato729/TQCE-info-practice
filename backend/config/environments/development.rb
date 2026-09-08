Rails.application.configure do
  # Docker Compose service name, used only for server-to-server development requests.
  config.hosts << "backend"
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store
  config.active_support.deprecation = :log
end
