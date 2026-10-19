require "test_helper"
require "rake"

class VerificationAccessTasksTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("verification_access:grant")
    @user = User.create!(name: "Task verification", email: "task-verification@example.com", password: "password123")
  end

  test "grant task records audit fields without creating a payment" do
    assert_no_difference("Payment.count") do
      assert_difference("VerificationAccessGrant.count", 1) { run_task("grant") }
    end
    grant = @user.reload.verification_access_grant
    assert grant.active?
    assert_equal "Owner approval", grant.granted_by
    assert_equal "Netlify QA", grant.reason
    assert_equal "user", @user.role
  end

  test "repeat grant does not overwrite an existing expiration" do
    run_task("grant")
    grant = @user.reload.verification_access_grant
    original_expiration = grant.expires_at
    assert_raises(ActiveRecord::RecordInvalid) { run_task("grant") }
    assert_equal original_expiration, grant.reload.expires_at
  end

  test "revoke task is repeatable and does not delete audit information" do
    run_task("grant")
    run_task("revoke")
    grant = @user.reload.verification_access_grant
    revoked_at = grant.revoked_at
    assert_not grant.active?
    run_task("revoke")
    assert_equal revoked_at, grant.reload.revoked_at
    assert_equal "Netlify QA", grant.reason
  end

  test "grant task refuses admin users" do
    @user.update!(role: "admin")
    assert_no_difference("VerificationAccessGrant.count") do
      assert_raises(SystemExit) { run_task("grant") }
    end
  end

  private

  def run_task(name)
    with_env(
      "USER_EMAIL" => @user.email, "REASON" => "Netlify QA", "GRANTED_BY" => "Owner approval",
      "EXPIRES_AT" => 1.day.from_now.iso8601,
    ) do
      task = Rake::Task["verification_access:#{name}"]
      task.reenable
      capture_io { task.invoke }
    end
  end
end
