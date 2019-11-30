# frozen_string_literal: true

require "test_helper"

class Pronto::BundlerAudit::ConfigurationTest < Minitest::Spec
  describe "Pronto::BundlerAudit::Configuration" do
    let(:base_klazz) { Pronto::BundlerAudit }
    let(:klazz) { base_klazz::Configuration }

    let(:config_file_path) { "test/fixtures/.test-pronto-bundler_audit.yml" }

    describe "#ignored_advisories" do
      context "GIVEN a Configuration File that exists" do
        context "GIVEN Advisories -> Ignore entries are present" do
          subject { klazz.new(path: config_file_path) }

          it "returns the expected Array" do
            value(subject.ignored_advisories).must_equal(%w[
              CVE-YYYY-####1
              CVE-YYYY-####2
            ])
          end
        end
      end

      context "GIVEN a Configuration File that doesn't exist" do
        subject { klazz.new(path: "non_existent_config_file.yml") }

        it "returns nil" do
          value(subject.ignored_advisories).must_be_nil
        end
      end
    end
  end
end
