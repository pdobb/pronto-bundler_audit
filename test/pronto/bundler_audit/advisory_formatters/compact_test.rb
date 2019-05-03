require "test_helper"

class Pronto::BundlerAudit::AdvisoryFormatters::CompactTest < Minitest::Spec
  describe "Pronto::BundlerAudit::AdvisoryFormatters::Compact" do
    let(:base_klazz) { Pronto::BundlerAudit }
    let(:klazz) { base_klazz::AdvisoryFormatters::Compact }

    describe "#to_s" do
      subject { klazz.new(gem: FakeGem.new, advisory: FakeAdvisory.new) }

      it "returns the expected String" do
        result = subject.to_s

        value(result).must_equal(
          "Gem: TEST_GEM_NAME vTEST_VERSION | "\
          "Test_criticality Advisory: TEST_TITLE -- CVE-TEST_CVE (TEST_URL) | "\
          "Solution: Upgrade to TEST_PATCHED_VERSION1.")
      end
    end
  end
end
