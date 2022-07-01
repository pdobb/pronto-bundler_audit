# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::AdvisoryFormatters::VerboseTest < Minitest::Spec
  describe "Pronto::BundlerAudit::AdvisoryFormatters::Verbose" do
    let(:unit_base_class) { Pronto::BundlerAudit }
    let(:unit_class) { unit_base_class::AdvisoryFormatters::Verbose }

    describe "#to_s" do
      subject { unit_class.new(FakeGem.new, FakeAdvisory.new) }

      it "returns the expected String" do
        result = subject.to_s

        value(result).must_equal(
          "Name: TEST_GEM_NAME\n"\
          "Version: TEST_VERSION\n"\
          "Advisory: CVE-TEST_CVE\n"\
          "Criticality: Test_criticality\n"\
          "URL: TEST_URL\n"\
          "Title: TEST_TITLE\n"\
          "Solution: Upgrade to TEST_PATCHED_VERSION1.")
      end
    end
  end
end
