ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*arguments|
  next unless ENV["ERROR_NOTIFICATIONS_ENABLED"] == "true"

  payload = arguments.last
  attributes = { controller: payload[:controller], status: payload[:status],
    exception_class: payload.dig(:exception, 0) }
  attributes[:expected_unavailability] = true if payload[:expected_unavailability] == true
  ApiErrorNotifier.call(**attributes)
rescue StandardError
  begin
    Rails.logger.error("API error notification subscriber failed")
  rescue StandardError
    nil
  end
end
