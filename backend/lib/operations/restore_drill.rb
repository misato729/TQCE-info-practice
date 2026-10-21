require "digest"
require "action_dispatch/testing/integration"
require "open3"
require "pg"
require "tmpdir"

module Operations
  class RestoreDrill
    class Error < StandardError; end
    LOCAL_HOSTS = %w[db localhost 127.0.0.1 ::1].freeze

    def call
      original = ActiveRecord::Base.connection_db_config.configuration_hash
      unless Rails.env.test? && LOCAL_HOSTS.include?(original[:host])
        raise Error, "Restore drill requires the local test environment"
      end
      if ActiveModel::Type::Boolean.new.cast(ENV.fetch("PAID_MEMBERSHIP_ENABLED", "false")) ||
          ENV["ERROR_NOTIFICATIONS_ENABLED"] == "true"
        raise Error, "Restore drill requires sales and error notifications disabled"
      end

      config = original.except(:url)
      created = []
      admin = PG.connect(pg_options(config).merge(dbname: "postgres"))
      verify_tool_versions!(admin)
      suffix = SecureRandom.hex(8)
      source = "tqce_drill_source_#{suffix}"
      target = "tqce_drill_target_#{suffix}"
      [source, target].each do |name|
        admin.exec("CREATE DATABASE #{PG::Connection.quote_ident(name)} TEMPLATE template0")
        created << name
      end

      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      connect(config, source)
      ActiveRecord::Migration.suppress_messages { load Rails.root.join("db/schema.rb") }
      password = SecureRandom.hex(24)
      create_synthetic_records(password: password)
      expected = fingerprint
      expected_constraints = constraints
      expected_indexes = indexes
      expected_sequences = sequences

      Dir.mktmpdir("tqce-restore-drill-") do |directory|
        File.chmod(0o700, directory)
        dump = File.join(directory, "synthetic.dump")
        run(pg_env(config, source), "pg_dump", "--format=custom", "--no-owner", "--no-acl", "--file", dump)
        File.chmod(0o600, dump)
        run(pg_env(config, target), "pg_restore", "--dbname", target, "--exit-on-error", "--single-transaction", "--no-owner", "--no-acl", dump)
      end

      connect(config, target)
      raise Error, "Restored rows do not match" unless fingerprint == expected
      raise Error, "Restored constraints do not match" unless constraints == expected_constraints
      raise Error, "Restored indexes do not match" unless indexes == expected_indexes
      raise Error, "Restored sequences do not match" unless sequences == expected_sequences
      verify_relationships!
      application_checks = verify_application_reads!(password: password)
      without_counters = ->(records) { records.except("api_rate_limit_buckets") }
      unless without_counters.call(fingerprint) == without_counters.call(expected)
        raise Error, "Application read checks changed restored records"
      end
      {
        status: "ok", data: "synthetic_only", tables: expected.length,
        row_counts: expected.transform_values { |value| value.fetch(:count) },
        constraints: expected_constraints.length, indexes: expected_indexes.length, sequences: expected_sequences.length,
        application_checks: application_checks,
        elapsed_seconds: (Process.clock_gettime(Process::CLOCK_MONOTONIC) - started).round(2),
      }
    ensure
      if admin
        ActiveRecord::Base.connection_pool.disconnect!
        cleanup_failed = created.filter_map do |name|
          admin.exec("DROP DATABASE #{PG::Connection.quote_ident(name)}")
          nil
        rescue PG::Error
          name
        end
        admin.close
        ActiveRecord::Base.establish_connection(original)
        raise Error, "Disposable database cleanup failed: #{cleanup_failed.join(', ')}" if cleanup_failed.any?
      end
    end

    private

    def connect(config, database)
      ActiveRecord::Base.connection_pool.disconnect!
      ActiveRecord::Base.establish_connection(config.merge(database: database))
    end

    def pg_options(config)
      { host: config[:host], port: config[:port] || 5432, user: config[:username], password: config[:password], connect_timeout: 10 }
    end

    def pg_env(config, database)
      {
        "PGHOST" => config[:host], "PGPORT" => (config[:port] || 5432).to_s,
        "PGUSER" => config[:username], "PGPASSWORD" => config[:password].to_s,
        "PGDATABASE" => database, "PGSERVICE" => nil, "PGOPTIONS" => "-c statement_timeout=60000",
      }
    end

    def run(environment, *command)
      _output, _error, status = Open3.capture3(environment, *command)
      raise Error, "#{command.first} failed; no connection details were logged" unless status.success?
    end

    def verify_tool_versions!(connection)
      server_major = connection.exec("SHOW server_version_num").getvalue(0, 0).to_i / 10_000
      %w[pg_dump pg_restore].each do |tool|
        output, _error, status = Open3.capture3(tool, "--version")
        unless status.success? && output[/PostgreSQL\) (\d+)/, 1].to_i == server_major
          raise Error, "Use pg_dump and pg_restore with the same major version as the test DB (see scripts/restore-drill.sh)"
        end
      end
    end

    def fingerprint
      connection = ActiveRecord::Base.connection
      connection.tables.sort.to_h do |table|
        rows = connection.select_values("SELECT row_to_json(t)::text FROM #{connection.quote_table_name(table)} t").sort
        [table, { count: rows.length, digest: Digest::SHA256.hexdigest(JSON.generate(rows)) }]
      end
    end

    def constraints
      ActiveRecord::Base.connection.select_rows(<<~SQL)
        SELECT c.relname, con.conname, pg_get_constraintdef(con.oid)
        FROM pg_constraint con JOIN pg_class c ON c.oid = con.conrelid
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE n.nspname = 'public' ORDER BY c.relname, con.conname
      SQL
    end

    def indexes
      ActiveRecord::Base.connection.select_rows("SELECT tablename, indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' ORDER BY tablename, indexname")
    end

    def sequences
      connection = ActiveRecord::Base.connection
      connection.select_values("SELECT sequencename FROM pg_sequences WHERE schemaname = 'public' ORDER BY sequencename").to_h do |name|
        [name, connection.select_rows("SELECT last_value, is_called FROM #{connection.quote_table_name(name)}")]
      end
    end

    def create_synthetic_records(password:)
      user = User.create!(name: "Restore drill", email: "restore@example.invalid", password: password)
      User.create!(name: "Restore admin", email: "restore-admin@example.invalid", password: password, role: "admin")
      question = Question.create!(
        exam_number: 6, question_number: 1, major_category_code: "teacher_education",
        category_code: "education_system", publication_status: "published",
        content_blocks: [{ type: "text", text: "Synthetic restore question" }],
        explanation_blocks: [{ type: "text", text: "Synthetic explanation" }],
        source_text: "Synthetic source | https://example.invalid/source",
      )
      choices = %w[ア イ ウ エ].map.with_index do |label, index|
        question.question_choices.create!(choice_label: label, display_order: index + 1,
          is_correct: index.zero?, content_blocks: [{ type: "text", text: "Synthetic choice #{index}" }])
      end
      AnswerHistory.create!(user: user, question: question, selected_choice: choices.first, is_correct: true)
      Favorite.create!(user: user, question: question)
      payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_test_restore_drill",
        stripe_payment_intent_id: "pi_test_restore_drill", stripe_price_id: "price_test_restore_drill",
        status: "paid", paid_at: Time.current)
      Membership.create!(user: user, source_payment: payment, status: "active", activated_at: Time.current)
      VerificationAccessGrant.create!(user: user, reason: "Synthetic restore drill", granted_by: "local-test", expires_at: 1.day.from_now)
      StripeWebhookEvent.create!(stripe_event_id: "evt_test_restore_drill", event_type: "checkout.session.completed",
        livemode: false, processed_at: Time.current)
    end

    def verify_relationships!
      user = User.find_by!(email: "restore@example.invalid")
      history = user.answer_histories.sole
      raise Error, "Choice relationship failed" unless history.selected_choice.question == history.question && history.selected_choice.is_correct?
      raise Error, "Favorite relationship failed" unless user.favorites.sole.question == history.question
      raise Error, "Payment relationship failed" unless user.membership.source_payment == user.payments.sole && user.paid_content_access?
      raise Error, "Verification grant failed" unless user.verification_access_grant.active?
      raise Error, "Admin role failed" unless User.find_by!(email: "restore-admin@example.invalid").role == "admin"
      raise Error, "Webhook record failed" unless StripeWebhookEvent.sole.event_type == "checkout.session.completed"
    end

    def verify_application_reads!(password:)
      session = ActionDispatch::Integration::Session.new(Rails.application)
      session.host! "localhost"
      health = request_json(session, :get, "/api/v1/health")
      raise Error, "Restored health check failed" unless health.fetch("status") == "ok"
      config = request_json(session, :get, "/api/v1/payments/config")
      raise Error, "Restored sales-off check failed" unless config.dig("data", "enabled") == false

      login = request_json(session, :post, "/api/v1/auth/login",
        params: { email: "restore@example.invalid", password: password }, as: :json)
      token = login.dig("data", "access_token")
      raise Error, "Restored login check failed" unless token.present?
      headers = { "Authorization" => "Bearer #{token}" }
      user = request_json(session, :get, "/api/v1/me", headers: headers)
      raise Error, "Restored entitlement check failed" unless user.dig("data", "paid_content_access") == true

      question = request_json(session, :get, "/api/v1/questions/next", params: { exam_number: 6 }, headers: headers).fetch("data")
      unless question.fetch("exam_number") == 6 && question.fetch("choices").length == 4 &&
          !question.key?("explanation_blocks") && question.fetch("choices").none? { |choice| choice.key?("is_correct") }
        raise Error, "Restored question check failed"
      end
      histories = request_json(session, :get, "/api/v1/answer_histories", headers: headers).fetch("data")
      favorites = request_json(session, :get, "/api/v1/favorites", headers: headers).fetch("data")
      unless histories.length == 1 && histories.first.dig("question", "id") == question.fetch("id") &&
          favorites.length == 1 && favorites.first.dig("question", "id") == question.fetch("id")
        raise Error, "Restored history or favorites check failed"
      end
      request_json(session, :get, "/api/v1/admin/questions", status: 403, headers: headers)
      request_json(session, :get, "/api/v1/admin/questions", status: 401)

      admin = request_json(session, :post, "/api/v1/auth/login",
        params: { email: "restore-admin@example.invalid", password: password }, as: :json)
      unless admin.dig("data", "user", "role") == "admin" && admin.dig("data", "access_token").present?
        raise Error, "Restored admin login check failed"
      end
      questions = request_json(session, :get, "/api/v1/admin/questions",
        headers: { "Authorization" => "Bearer #{admin.dig('data', 'access_token')}" }).fetch("data")
      raise Error, "Restored admin read check failed" unless questions.length == 1 && questions.first.fetch("id") == question.fetch("id")

      11
    end

    def request_json(session, method, path, status: 200, **options)
      session.public_send(method, path, **options)
      raise Error, "Restored application check failed: #{method.upcase} #{path}" unless session.response.status == status

      JSON.parse(session.response.body)
    end
  end
end
