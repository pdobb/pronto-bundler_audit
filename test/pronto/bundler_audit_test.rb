require "test_helper"

class Pronto::BundlerAuditTest < Minitest::Spec
  describe "Pronto::BundlerAudit" do
    let(:klazz) { Pronto::BundlerAudit }

    describe "#run" do
      before do
        @fake_auditor = nil
        @auditor_called_with = nil
        MuchStub.stub(klazz::Auditor, :new) { |*args|
          @auditor_called_with = args
          @fake_auditor = FakeAuditor.new(*args)
        }
      end

      after do
        MuchStub.unstub!
      end

      context "GIVEN Pronto::Git::Patch#additions > 0" do
        context "GIVEN Pronto::Git::Patch#new_file_full_path ends with Gemfile.lock" do
          subject { klazz.new([patch1]) }

          let(:patch1) {
            FakePatch.new(additions: 1, path: "test/path/Gemfile.lock")
          }

          it "calls Pronto::BundlerAudit::Auditor" do
            subject.run

            value(@auditor_called_with).must_equal([patch1])
          end
        end

        context "GIVEN Pronto::Git::Patch#new_file_full_path does not end with Gemfile.lock" do
          subject {
            klazz.new([
              FakePatch.new(additions: 1, path: "test/path/UNKNOWN_FILE")
            ])
          }

          it "does not call Pronto::BundlerAudit::Auditor" do
            value(subject.run).must_be_kind_of(Array)
            value(@fake_auditor).must_be_nil
          end
        end
      end

      context "GIVEN Pronto::Git::Patch#additions = 0" do
        subject { klazz.new([FakePatch.new(additions: 0)]) }

        it "does not call Pronto::BundlerAudit::Auditor" do
          value(subject.run).must_be_kind_of(Array)
          value(@fake_auditor).must_be_nil
        end
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
