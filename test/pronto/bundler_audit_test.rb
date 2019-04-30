require "test_helper"

class Pronto::BundlerAuditTest < Minitest::Spec
  describe "Pronto::BundlerAudit" do
    let(:klazz) { Pronto::BundlerAudit }

    describe "#run" do
      context "GIVEN Pronto::Git::Patch#additions > 0" do
        subject { klazz.new([FakePatch.new(additions: 1)]) }

        context "GIVEN Pronto::Git::Patch#new_file_full_path ends with "\
                "Gemfile.lock" do
          subject {
            klazz.new([
              FakePatch.new(additions: 1, path: "test/path/Gemfile.lock")
            ])
          }

          it "calls Pronto::BundlerAudit::PatchHandler" do
            klazz::PatchHandler.any_instance.expects(:call)

            subject.run
          end
        end

        context "GIVEN Pronto::Git::Patch#new_file_full_path does not end "\
                "with Gemfile.lock" do
          subject {
            klazz.new([
              FakePatch.new(additions: 1, path: "test/path/UNKNOWN_FILE")
            ])
          }

          it "does not call Pronto::BundlerAudit::PatchHandler" do
            klazz::PatchHandler.any_instance.expects(:call).never

            subject.run
          end
        end
      end

      context "GIVEN Pronto::Git::Patch#additions = 0" do
        subject { klazz.new([FakePatch.new(additions: 0)]) }

        it "does not Pronto::BundlerAudit::PatchHandler" do
          klazz::PatchHandler.any_instance.expects(:call).never

          subject.run
        end
      end
    end
  end
end
