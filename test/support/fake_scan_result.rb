# frozen_string_literal: true

# FakeScanResult is a test double for Bundler::Audit::Scanner::* types.
class FakeScanResult
  def gem
    FakeGem.new
  end

  def advisory
    FakeAdvisory.new
  end

  def source
    "TEST_SOURCE"
  end
end
