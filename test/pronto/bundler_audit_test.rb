# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAuditTest < Minitest::Spec
  describe "Pronto::BundlerAudit" do
    let(:klazz) { Pronto::BundlerAudit }

    describe "#run" do
      before do
        @fake_auditor = nil
        @auditor_called_with = nil
        MuchStub.(klazz::Auditor, :new) { |*args|
          @auditor_called_with = args
          @fake_auditor = FakeAuditor.new(*args)
        }
      end

      subject { klazz.new([]) }

      it "calls Pronto::BundlerAudit::Auditor" do
        subject.run

        value(@auditor_called_with).must_equal([])
      end
    end
  end

  class FakeAuditor
    def initialize(*)
    end

    def call
      # Do nothing.
    end
  end
end
