require "test_helper"

class ApiRateLimiterConcurrencyTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  setup { ApiRateLimitBucket.delete_all }
  teardown { ApiRateLimitBucket.delete_all }

  test "parallel connections cannot pass more requests than the shared quota" do
    now = Time.current
    results = Queue.new
    threads = 4.times.map do
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          10.times { results << ApiRateLimiter.call(scope: :login, subject: "192.0.2.50", now: now).allowed }
        end
      end
    end
    threads.each(&:value)
    assert_equal 30, 40.times.count { results.pop }
    assert_equal 40, ApiRateLimitBucket.first.request_count
  end
end
