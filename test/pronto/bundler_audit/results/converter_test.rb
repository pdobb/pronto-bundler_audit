# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::Results::ConverterTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Results::Converter" do
    subject { Pronto::BundlerAudit::Results::Converter.new(results, "commit", "path") }

    describe "#call" do
      context "when the results are empty" do
        let(:results) { [] }
        it "returns an empty array" do
          value(subject.call).must_equal([])
        end
      end

      context "when a valid set of results are available" do
        MyStub = Struct.new(:message, :line, :level)
        let(:results) do
          [MyStub.new("result 1", 100, :error)]
        end

        it "returns an array of Pronto::Message" do
          result = subject.call

          value(result).must_be_kind_of(Array)
          value(result.size).must_equal(1)
          value(result.first).must_be_kind_of(Pronto::Message)
        end
      end
    end
  end
end
