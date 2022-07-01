# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::Results::UnpatchedGemTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Results::UnpatchedGem" do
    let(:unit_base_class) { Pronto::BundlerAudit }
    let(:unit_class) { unit_base_class::Results::UnpatchedGem }

    describe "#level" do
      subject { unit_class.new(FakeScanResult.new) }

      it "returns :error" do
        value(subject.level).must_equal(:error)
      end
    end

    describe "#line" do
      before do
        @gemfile_lock_scanner_called_with = nil
        MuchStub.(unit_base_class::GemfileLock::Scanner, :new) { |*args|
          @gemfile_lock_scanner_called_with = args
          FakeGemfileLockScanner.new(*args)
        }
      end

      subject { unit_class.new(FakeScanResult.new) }

      it "returns an Integer" do
        result = subject.line

        value(@gemfile_lock_scanner_called_with.dig(0)).
          must_equal("TEST_GEM_NAME")

        value(result).must_be_kind_of(Integer)
        value(result).must_equal(99)
      end
    end

    describe "#message" do
      before do
        @verbose_advisory_formatter_called_with = nil
        MuchStub.(unit_base_class::AdvisoryFormatters::Verbose, :new) { |*args|
          @verbose_advisory_formatter_called_with = args
          FakeVerboseAdvisoryFormatter.new(*args)
        }
      end

      subject { unit_class.new(FakeScanResult.new) }

      it "returns a String" do
        result = subject.message

        value(@verbose_advisory_formatter_called_with.dig(0)).
          must_be_kind_of(FakeGem)
        value(@verbose_advisory_formatter_called_with.dig(1)).
          must_be_kind_of(FakeAdvisory)

        value(result).must_be_kind_of(String)
        value(result).must_equal("TEST_ADVISORY")
      end
    end
  end

  class FakeVerboseAdvisoryFormatter
    def initialize(*)
    end

    def to_s
      "TEST_ADVISORY"
    end
  end

  class FakeGemfileLockScanner
    def initialize(*)
    end

    def call
      99
    end
  end
end
