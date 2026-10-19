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
end
