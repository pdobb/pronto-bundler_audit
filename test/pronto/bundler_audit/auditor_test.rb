require "test_helper"

class Pronto::BundlerAudit::AuditorTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Auditor" do
    let(:base_klazz) { Pronto::BundlerAudit }
    let(:klazz) { base_klazz::Auditor }

    let(:patch1) { FakePatch.new }

    describe "#call" do
      before do
        @bundler_audit_database_called_with = nil
        MuchStub.stub(Bundler::Audit::Database, :update!) { |*args|
          @bundler_audit_database_called_with = args
        }

        @scanner_called_with = nil
        MuchStub.stub(base_klazz::Scanner, :new) { |*args|
          @scanner_called_with = args
          FakeScanner.new(*args)
        }
      end

      after do
        MuchStub.unstub!
      end

      subject { klazz.new(patch1) }

      it "calls Bundler::Audit::Database.update! and Pronto::BundlerAudit::Scanner" do
        subject.call

        value(@bundler_audit_database_called_with).must_equal([quiet: true])
        value(@scanner_called_with).must_equal([patch1])
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
