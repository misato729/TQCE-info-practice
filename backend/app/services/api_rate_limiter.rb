require "openssl"

class ApiRateLimiter
  class Unavailable < StandardError; end

  Result = Data.define(:allowed, :retry_after)
  RULES = {
    signup: { limit: 10, period: 15.minutes },
    login: { limit: 30, period: 5.minutes },
    checkout_ip: { limit: 20, period: 5.minutes },
    checkout_user: { limit: 10, period: 5.minutes },
    answer: { limit: 120, period: 1.minute },
  }.freeze

  def self.call(scope:, subject:, now: Time.current)
    rule = RULES.fetch(scope)
    period = rule.fetch(:period).to_i
    window_start = now.to_i.div(period) * period
    expires_at = Time.at(window_start + period).utc
    key = OpenSSL::HMAC.hexdigest("SHA256", Rails.application.secret_key_base,
      ["api-rate-limit-v1", scope, subject, window_start].join("\0"))

    ApiRateLimitBucket.where("expires_at <= ?", now).limit(100).delete_all
    # PostgreSQL serializes concurrent increments, including across app machines.
    result = ApiRateLimitBucket.upsert_all(
      [{ key: key, request_count: 1, expires_at: expires_at }],
      unique_by: :key,
      on_duplicate: Arel.sql("request_count = api_rate_limit_buckets.request_count + 1"),
      returning: %w[request_count],
    )
    Result.new(allowed: result.rows.fetch(0).fetch(0) <= rule.fetch(:limit),
      retry_after: [(expires_at.to_f - now.to_f).ceil, 1].max)
  rescue ActiveRecord::ActiveRecordError
    raise Unavailable, cause: nil
  end
end
