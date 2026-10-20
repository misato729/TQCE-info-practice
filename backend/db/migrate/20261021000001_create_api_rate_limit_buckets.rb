class CreateApiRateLimitBuckets < ActiveRecord::Migration[7.1]
  def change
    create_table :api_rate_limit_buckets, id: false do |t|
      t.string :key, limit: 64, null: false, primary_key: true
      t.bigint :request_count, null: false
      t.datetime :expires_at, null: false
    end

    add_index :api_rate_limit_buckets, :expires_at
    add_check_constraint :api_rate_limit_buckets, "request_count > 0", name: "api_rate_limit_count_positive"
  end
end
