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

          value(result).must_be_kind_of(::Pronto::Git::Line)
          value(result.new_lineno).must_equal(3)
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

    describe "Pronto::BundlerAudit::GemfileLock::Scanner::Line" do
      let(:klazz) { base_klazz::GemfileLock::Scanner::Line }

      context "GIVEN a line_number" do
        let(:line_number) { 99 }

        subject { klazz.new(line_number) }

        describe "#new_lineno" do
          it "returns the initialized line number" do
            value(subject.new_lineno).must_equal(line_number)
          end
        end

        describe "#position" do
          it "returns 0" do
            value(subject.position).must_equal(0)
          end
        end
      end
    end

    describe "Pronto::BundlerAudit::GemfileLock::Scanner::Patch" do
      let(:klazz) { base_klazz::GemfileLock::Scanner::Patch }

      subject { klazz.new }

      it "responds to #blame" do
        value(subject.respond_to?(:blame)).must_equal(true)
      end

      it "responds to #repo" do
        value(subject.respond_to?(:repo)).must_equal(true)
      end

      describe "#lines" do
        it "returns an empty Array" do
          value(subject.lines).must_equal([])
        end
      end
    end
  end
end
