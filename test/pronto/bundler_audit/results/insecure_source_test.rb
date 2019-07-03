# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::Results::InsecureSourceTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Results::InsecureSource" do
    let(:base_klazz) { Pronto::BundlerAudit }
    let(:klazz) { base_klazz::Results::InsecureSource }

    describe "#level" do
      subject { klazz.new(FakeScanResult.new) }

      it "returns :warning" do
        value(subject.level).must_equal(:warning)
      end
    end

    describe "#line" do
      subject { klazz.new(FakeScanResult.new) }

      it "returns nil" do
        result = subject.line

        value(result).must_be_nil
      end
    end

    describe "#message" do
      subject { klazz.new(FakeScanResult.new) }

      it "returns a Pronto::Message" do
        result = subject.message

        value(result).must_be_kind_of(String)
        value(result).must_equal("Insecure Source URI found: TEST_SOURCE")
      end
    end
  end
end
