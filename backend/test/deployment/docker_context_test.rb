require "test_helper"

class DockerContextTest < ActiveSupport::TestCase
  test "local secrets and tests are excluded from production images" do
    patterns = Rails.root.join(".dockerignore").read.lines.map(&:strip)

    %w[.env .env.* config/master.key config/credentials/*.key test].each do |pattern|
      assert_includes patterns, pattern
    end

    %w[Gemfile Gemfile.lock config/credentials.yml.enc app].each do |path|
      refute_includes patterns, path
    end
  end
end
