require "test_helper"

class Pronto::BundlerAuditVersionTest < Minitest::Spec
  describe "Pronto::BundlerAuditVersion" do
    let(:klazz) { Pronto::BundlerAuditVersion }

    describe "::VERSION" do
      it "is not nil" do
        value(Pronto::BundlerAuditVersion::VERSION).wont_be_nil
      end
    end
  end
end
