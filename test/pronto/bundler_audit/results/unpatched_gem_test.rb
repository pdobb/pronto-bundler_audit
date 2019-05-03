# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::Results::UnpatchedGemTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Results::UnpatchedGem" do
    let(:base_klazz) { Pronto::BundlerAudit }
    let(:klazz) { base_klazz::Results::UnpatchedGem }

    describe "#call" do
      before do
        @verbose_advisory_formatter_called_with = nil
        MuchStub.stub(base_klazz::AdvisoryFormatters::Verbose, :new) { |*args|
          @verbose_advisory_formatter_called_with = args
          FakeVerboseAdvisoryFormatter.new(*args)
        }
      end

      after do
        MuchStub.unstub!
      end

      subject { klazz.new(FakeScanResult.new, patch: FakePatch.new) }

      it "returns a Pronto::Message" do
        result = subject.call

        value(@verbose_advisory_formatter_called_with.dig(0, :gem)).
          must_be_kind_of(FakeGem)
        value(@verbose_advisory_formatter_called_with.dig(0, :advisory)).
          must_be_kind_of(FakeAdvisory)

        value(result).must_be_kind_of(Pronto::Message)
        value(result.msg).must_equal("TEST_ADVISORY")
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
end
