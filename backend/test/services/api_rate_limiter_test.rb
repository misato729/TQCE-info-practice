require "test_helper"
require_relative "../support/method_replacement"

class ApiRateLimiterTest < ActiveSupport::TestCase
  include MethodReplacement

  test "fixed windows share counters across callers and reset at their boundary" do
    now = Time.utc(2026, 10, 21, 0, 0, 0)
    30.times { assert ApiRateLimiter.call(scope: :login, subject: "192.0.2.1", now: now).allowed }
    limited = ApiRateLimiter.call(scope: :login, subject: "192.0.2.1", now: now + 10.2)
    assert_not limited.allowed
    assert_equal 290, limited.retry_after
    assert ApiRateLimiter.call(scope: :login, subject: "192.0.2.1", now: now + 5.minutes).allowed
    assert_equal 1, ApiRateLimitBucket.count
  end

  test "subjects and operations have independent limits without storing identities" do
    %w[192.0.2.1 192.0.2.2].each do |address|
      assert ApiRateLimiter.call(scope: :login, subject: address).allowed
      assert ApiRateLimiter.call(scope: :signup, subject: address).allowed
    end
    assert_equal 4, ApiRateLimitBucket.count
    ApiRateLimitBucket.all.each { |bucket| assert_match(/\A[a-f0-9]{64}\z/, bucket.key) }
    assert_not_includes ApiRateLimitBucket.all.to_json, "192.0.2."
  end

  test "expired bucket deletion is bounded and preserves active buckets" do
    now = Time.current
    rows = 110.times.map { |n| { key: Digest::SHA256.hexdigest(n.to_s), request_count: 1, expires_at: now - 1.minute } }
    ApiRateLimitBucket.insert_all!(rows)
    ApiRateLimiter.call(scope: :answer, subject: "192.0.2.1", now: now)
    assert_equal 10, ApiRateLimitBucket.where("expires_at <= ?", now).count
    assert_equal 1, ApiRateLimitBucket.where("expires_at > ?", now).count
  end

  test "database failures do not bypass the limit or expose database errors" do
    with_method_replacement(ApiRateLimitBucket, :upsert_all, ->(*) { raise ActiveRecord::StatementInvalid, "sensitive database details" }) do
      error = assert_raises(ApiRateLimiter::Unavailable) { ApiRateLimiter.call(scope: :login, subject: "192.0.2.1") }
      assert_nil error.cause
      assert_not_includes error.message, "sensitive"
    end
  end
end
