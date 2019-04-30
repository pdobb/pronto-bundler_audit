require "test_helper"

class Pronto::BundlerAudit::PatchHandlerTest < Minitest::Spec
  describe "Pronto::BundlerAudit::PatchHandler" do
    let(:klazz) { Pronto::BundlerAudit::PatchHandler }

    let(:patch1) { FakePatch.new }
    let(:runner1) { Pronto::BundlerAudit.new([patch1]) }

    describe "#call" do
      subject { klazz.new(patch1, runner: runner1) }

      it "calls Bundler::Audit::Database.update!" do
        Bundler::Audit::Database.expects(:update!)
        subject.stubs(:run_scan)

        subject.call
      end

      it "calls Pronto::BundlerAudit::PatchHandler#run_scan" do
        Bundler::Audit::Database.stubs(:update!)
        subject.expects(:run_scan)

        subject.call
      end
    end
  end

  # FakeScanner is a test double for Bundler::Audit::Scanner.
  # class FakeScanner
  #   def initialize(result:)
  #     @result = result
  #   end

  #   def scan
  #     Array(@result)
  #   end
  # end

  # FakeInsecureSource is a result type for FakeScanner.
  # class FakeInsecureSource
  #   def ===(other)
  #     other.instance_of?(Bundler::Audit::Scanner::InsecureSource)
  #   end
  # end

  # FakeUnpatchedGem is a result type for FakeScanner.
  # class FakeUnpatchedGem
  #   def ===(other)
  #     other.instance_of?(Bundler::Audit::Scanner::UnpatchedGem)
  #   end
  # end

  # FakeMessage is a test double for Pronto::Message.
  # class FakeMessage
  #   attr_reader :path, :line, :level, :msg, :commit_sha, :runner

  #   def initialize(path, line, level, msg, commit_sha = nil, runner = nil)
  #     @path = path
  #     @line = line
  #     @level = level
  #     @msg = msg
  #     @commit_sha = commit_sha
  #     @runner = runner
  #   end
  # end
end
