# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::GemfileLock::ScannerTest < Minitest::Spec
  describe "Pronto::BundlerAudit::GemfileLock::Scanner" do
    let(:unit_base_class) { Pronto::BundlerAudit }
    let(:unit_class) { unit_base_class::GemfileLock::Scanner }

    describe "#initialize" do
      context "GIVEN an unknown Gemfile.lock path" do
        subject {
          unit_class.new(
            "TEST_GEM_NAME",
            File.join("test", "fixtures", "UNKNOWNGemfile.lock"))
        }

        it "returns the expected line number" do
          exception =
            value(-> { subject.call }).must_raise(ArgumentError)
          value(exception.message).must_equal("Gemfile.lock path not found")
        end
      end
    end

    describe "#call" do
      context "GIVEN the Gemfile.lock has a matching gem" do
        subject {
          unit_class.new(
            "TEST_GEM_NAME",
            File.join("test", "fixtures", "Gemfile.lock"))
        }

        it "returns the expected line number" do
          result = subject.call

          value(result).must_equal(3)
        end
      end

      context "GIVEN the Gemfile.lock doesn't have a matching gem" do
        subject {
          unit_class.new(
            "UNKNOWN_GEM",
            File.join("test", "fixtures", "Gemfile.lock"))
        }

        it "returns 0" do
          value(subject.call).must_equal(0)
        end
      end
    end
  end
end
