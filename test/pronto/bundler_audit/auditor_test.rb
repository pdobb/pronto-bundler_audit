# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::AuditorTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Auditor" do
    let(:base_klazz) { Pronto::BundlerAudit }
    let(:klazz) { base_klazz::Auditor }

    describe "#call" do
      before do
        @bundler_audit_database_called_with = nil
        MuchStub.(Bundler::Audit::Database, :update!) { |*args|
          @bundler_audit_database_called_with = args
        }

        @pronto_bundler_audit_scanner_called_with = nil
        MuchStub.(base_klazz::Scanner, :new) { |*args|
          @pronto_bundler_audit_scanner_called_with = args
          FakeScanner.new(*args)
        }
      end

      subject { klazz.new }

      it "calls Bundler::Audit::Database.update! and "\
         "Pronto::BundlerAudit::Scanner" do
        subject.call

        value(@bundler_audit_database_called_with).must_equal([quiet: true])
        value(@pronto_bundler_audit_scanner_called_with).must_equal([])
      end
    end
  end

  class FakeScanner
    def initialize(*)
    end

    def call
      # Do nothing.
    end
  end
end
