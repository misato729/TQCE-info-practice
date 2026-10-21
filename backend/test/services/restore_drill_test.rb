require "test_helper"
require_relative "../../lib/operations/restore_drill"

class RestoreDrillTest < ActiveSupport::TestCase
  test "refuses production before creating or changing databases" do
    original_environment = Rails.env
    Rails.env = "production"
    error = assert_raises(Operations::RestoreDrill::Error) { Operations::RestoreDrill.new.call }
    assert_equal "Restore drill requires the local test environment", error.message
  ensure
    Rails.env = original_environment
  end

  test "refuses an enabled sales flag before creating disposable databases" do
    with_env("PAID_MEMBERSHIP_ENABLED" => "true", "ERROR_NOTIFICATIONS_ENABLED" => "false") do
      error = assert_raises(Operations::RestoreDrill::Error) { Operations::RestoreDrill.new.call }
      assert_equal "Restore drill requires sales and error notifications disabled", error.message
    end
  end

  test "refuses enabled error notifications before creating disposable databases" do
    with_env("PAID_MEMBERSHIP_ENABLED" => "false", "ERROR_NOTIFICATIONS_ENABLED" => "true") do
      error = assert_raises(Operations::RestoreDrill::Error) { Operations::RestoreDrill.new.call }
      assert_equal "Restore drill requires sales and error notifications disabled", error.message
    end
  end
end
