ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class TestObject
  def initialize(**attributes)
    attributes.each do |name, value|
      singleton_class.attr_accessor(name)
      public_send("#{name}=", value)
    end
  end
end

module ActiveSupport
  class TestCase
    parallelize(workers: 1)

    private

    def with_env(overrides)
      previous = overrides.to_h { |key, _value| [key, ENV.key?(key) ? ENV[key] : :missing] }
      overrides.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
      yield
    ensure
      previous.each { |key, value| value == :missing ? ENV.delete(key) : ENV[key] = value }
    end
  end
end
