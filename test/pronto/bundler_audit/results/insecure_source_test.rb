# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::Results::InsecureSourceTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Results::InsecureSource" do
    let(:base_klazz) { Pronto::BundlerAudit }
    let(:klazz) { base_klazz::Results::InsecureSource }

    describe "#call" do
      subject { klazz.new(FakeScanResult.new) }

      it "returns a Pronto::Message" do
        result = subject.call

        value(result.message).must_equal(
          "Insecure Source URI found: TEST_SOURCE")
      end
    end
  end
end
