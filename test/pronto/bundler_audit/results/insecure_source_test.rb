# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::Results::InsecureSourceTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Results::InsecureSource" do
    let(:unit_base_class) { Pronto::BundlerAudit }
    let(:unit_class) { unit_base_class::Results::InsecureSource }

    describe "#level" do
      subject { unit_class.new(FakeScanResult.new) }

      it "returns :warning" do
        value(subject.level).must_equal(:warning)
      end
    end

    describe "#line" do
      subject { unit_class.new(FakeScanResult.new) }

      it "returns nil" do
        result = subject.line

        value(result).must_be_nil
      end
    end

    describe "#message" do
      subject { unit_class.new(FakeScanResult.new) }

      it "returns a Pronto::Message" do
        result = subject.message

        value(result).must_be_kind_of(String)
        value(result).must_equal("Insecure Source URI found: TEST_SOURCE")
      end
    end
  end
end
