# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAuditTest < Minitest::Spec
  describe "Pronto::BundlerAudit" do
    let(:klazz) { Pronto::BundlerAudit }

    before do
      @pronto_bundler_audit_auditor_called_with = nil
      MuchStub.(klazz::Auditor, :new) { |*args|
        @pronto_bundler_audit_auditor_called_with = args
        FakeAuditor.new(*args)
      }
    end

    describe "#run" do
      subject { klazz.new([]) }

      it "calls Pronto::BundlerAudit::Auditor" do
        results = subject.run

        value(@pronto_bundler_audit_auditor_called_with).must_equal([])
        value(results).must_be_kind_of(Array)

        result = results.sample
        value(result).must_be_kind_of(::Pronto::Message)
      end
    end

    describe "#path" do
      subject { klazz.new([]) }

      it "returns the expected Pathname" do
        value(subject.path).must_be_kind_of(Pathname)
        value(subject.path.to_s).must_equal(File.expand_path("."))
      end
    end

    describe "#filename" do
      subject { klazz.new([]) }

      it "returns 'Gemfile.lock'" do
        value(subject.filename).must_equal("Gemfile.lock")
      end
    end

    describe "#commit_sha" do
      subject { klazz.new([]) }

      it "returns nil" do
        value(subject.commit_sha).must_be_nil
      end
    end
  end

  class FakeAuditor
    def initialize(*)
    end

    def call
      [FakeResult.new]
    end
  end
end
