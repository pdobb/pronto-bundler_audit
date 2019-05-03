require "test_helper"

class Pronto::BundlerAudit::AdvisoryFormatters::VerboseTest < Minitest::Spec
  describe "Pronto::BundlerAudit::AdvisoryFormatters::Verbose" do
    let(:base_klazz) { Pronto::BundlerAudit }
    let(:klazz) { base_klazz::AdvisoryFormatters::Verbose }

    describe "#to_s" do
      subject { klazz.new(gem: FakeGem.new, advisory: FakeAdvisory.new) }

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
