# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::ScannerTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Scanner" do
    let(:unit_base_class) { Pronto::BundlerAudit }
    let(:unit_class) { unit_base_class::Scanner }

    describe "#call" do
      context "GIVEN a Bundler::Audit::Scanner::InsecureSource is found" do
        before do
          @bundler_audit_scanner_called_with = nil
          MuchStub.(Bundler::Audit::Scanner, :new) { |*args|
            @bundler_audit_scanner_called_with = args
            FakeInsecureSourceBundlerAuditScanner.new(*args)
          }

          @insecure_source_result_called_with = nil
          MuchStub.(unit_base_class::Results::InsecureSource, :new) { |*args|
            @insecure_source_result_called_with = args
            FakeInsecureSourceResult.new(*args)
          }
        end

        subject { unit_class.new }

        it "calls a Results::InsecureSource instance with the scan result" do
          subject.call

          value(@bundler_audit_scanner_called_with).must_equal([])
          value(@insecure_source_result_called_with.first).
            must_be_kind_of(Bundler::Audit::Scanner::InsecureSource)
        end
      end

      context "GIVEN a Bundler::Audit::Scanner::UnpatchedGem is found" do
        before do
          @bundler_audit_scanner_called_with = nil
          MuchStub.(Bundler::Audit::Scanner, :new) { |*args|
            @bundler_audit_scanner_called_with = args
            FakeUnpatchedGemBundlerAuditScanner.new(*args)
          }

          @unpatched_gem_result_called_with = nil
          MuchStub.(unit_base_class::Results::UnpatchedGem, :new) { |*args|
            @unpatched_gem_result_called_with = args
            FakeUnpatchedGemResult.new(*args)
          }
        end

        subject { unit_class.new }

        it "calls a Results::UnpatchedGem instance with the scan result" do
          subject.call

          value(@bundler_audit_scanner_called_with).must_equal([])
          value(@unpatched_gem_result_called_with.first).
            must_be_kind_of(Bundler::Audit::Scanner::UnpatchedGem)
        end
      end

      context "GIVEN an unknown Bundler::Audit::Scanner::* type is found" do
        before do
          @bundler_audit_scanner_called_with = nil
          MuchStub.(Bundler::Audit::Scanner, :new) { |*args|
            @bundler_audit_scanner_called_with = args
            FakeUnknownBundlerAuditScanner.new(*args)
          }
        end

        subject { unit_class.new }

        it "raises ArgumentError" do
          exception = value(-> { subject.call }).must_raise(ArgumentError)
          value(exception.message).must_equal(
            "Unexpected type: "\
            "Pronto::BundlerAudit::ScannerTest::FakeUnknownResultType")

          value(@bundler_audit_scanner_called_with).must_equal([])
        end
      end
    end
  end

  class FakeInsecureSourceBundlerAuditScanner
    def scan(*)
      [Bundler::Audit::Scanner::InsecureSource.new]
    end
  end

  class FakeInsecureSourceResult
    def initialize(*)
    end

    def call
      # Do nothing.
    end
  end

  class FakeUnpatchedGemBundlerAuditScanner
    def scan(*)
      [Bundler::Audit::Scanner::UnpatchedGem.new]
    end
  end

  class FakeUnpatchedGemResult
    def initialize(*)
    end

    def call
      # Do nothing.
    end
  end

  class FakeUnknownBundlerAuditScanner
    def scan(*)
      [FakeUnknownResultType.new]
    end
  end

  class FakeUnknownResultType
  end
end
