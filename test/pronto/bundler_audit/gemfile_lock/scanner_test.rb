# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::GemfileLock::ScannerTest < Minitest::Spec
  describe "Pronto::BundlerAudit::GemfileLock::Scanner" do
    let(:base_klazz) { Pronto::BundlerAudit }
    let(:klazz) { base_klazz::GemfileLock::Scanner }

    describe "#call" do
      context "GIVEN the Gemfile.lock has a matching gem" do
        subject {
          klazz.new(
            gem_name: "TEST_GEM_NAME",
            path: File.join("test", "fixtures", "Gemfile.lock"))
        }

        it "returns the expected line number" do
          result = subject.call
          value(result).must_equal(3)
        end
      end

      context "GIVEN the Gemfile.lock doesn't have a matching gem" do
        subject {
          klazz.new(
            gem_name: "UNKNOWN_GEM",
            path: File.join("test", "fixtures", "Gemfile.lock"))
        }

        it "returns nil" do
          value(subject.call).must_be_nil
        end
      end
    end
  end
end
