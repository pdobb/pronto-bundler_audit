# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/bin/"
  add_filter "/images/"
  add_filter "/pkg/"
  add_filter "/test/"
end
puts "SimpleCov enabled."

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "pronto/bundler_audit"

require "minitest/autorun"
require "minitest/reporters"
require "much-stub"
require "pry"

Dir[File.join("test", "support", "*.rb")].each { |path|
  require "support/#{File.basename(path)}"
}

reporter_options = { color: true }
Minitest::Reporters.use!(
  Minitest::Reporters::DefaultReporter.new(reporter_options))

Minitest::Test.make_my_diffs_pretty!

class Minitest::Spec
  def teardown
    MuchStub.unstub!
  end
end

def context(*args, &block)
  describe(*args, &block)
end
