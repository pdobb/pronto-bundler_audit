# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::Results::ProntoMessagesAdapterTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Results::ProntoMessagesAdapter" do
    let(:unit_base_class) { Pronto::BundlerAudit }
    let(:unit_class) { unit_base_class::Results::ProntoMessagesAdapter }

    describe ".call" do
      subject { unit_class.new(results, FakeRunner.new) }

      context "GIVEN results = nil" do
        let(:results) { nil }

        it "returns an empty Array" do
          results = subject.call

          value(results).must_equal([])
        end
      end

      context "GIVEN results = []" do
        let(:results) { [] }

        it "returns an empty Array" do
          results = subject.call

          value(results).must_equal([])
        end
      end

      context "GIVEN a non-empty Array of results" do
        let(:results) { [FakeResult.new, FakeResult.new] }

        it "returns an Array of ::Pronto::Message objects" do
          results = subject.call

          value(results).must_be_kind_of(Array)
          value(results.size).must_equal(2)

          result = results.sample
          value(result).must_be_kind_of(::Pronto::Message)
          value(result.level).must_equal(:error)
          value(result.line).must_be_kind_of(unit_class::DeepLine)
          value(result.msg).must_equal("FAKE_RESULT_MESSAGE")
        end
      end
    end

    describe "Pronto::BundlerAudit::Results::ProntoMessagesAdapter::DeepLine" do
      let(:unit_class) {
        unit_base_class::Results::ProntoMessagesAdapter::DeepLine
      }

      subject {
        unit_class.new(99, Pathname.new("TEST_PATH"))
      }

      describe "#line_number" do
        it "returns the expected Integer" do
          value(subject.line_number).must_equal(99)
        end
      end

      describe "#new_lineno" do
        it "returns the expected Integer" do
          value(subject.new_lineno).must_equal(99)
        end
      end

      describe "#commit_sha" do
        it "returns nil" do
          value(subject.commit_sha).must_be_nil
        end
      end

      describe "#path" do
        it "returns the expected Pathname" do
          value(subject.path.to_s).must_equal("TEST_PATH")
        end
      end

      describe "#repo" do
        it "returns itself" do
          value(subject.repo).must_equal(subject)
        end
      end

      describe "#patch" do
        it "returns itself" do
          value(subject.patch).must_equal(subject)
        end
      end
    end
  end

  class FakeRunner
    def path
      Pathname.new("TEST_PATH")
    end

    def filename
      "TEST_FILENAME"
    end

    def commit_sha
      "TEST_COMMIT_SHA"
    end
  end
end
