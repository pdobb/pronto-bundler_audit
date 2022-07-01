# frozen_string_literal: true

require "pronto"

# Pronto gem overrides (use sparingly):
require "formatter/github_pull_request_review_formatter"

require "bundler/audit/database"
require "bundler/audit/scanner"

module Pronto
  # Pronto::BundlerAudit is a ::Pronto::Runner that:
  # 1. Updates the Ruby Advisory Database,
  # 2. Runs bundle-audit to scan the Gemfile.lock, and then
  # 3. Returns an Array of ::Pronto::Message objects if any issues or advisories
  #    are found.
  class BundlerAudit < ::Pronto::Runner
    GEMFILE_LOCK_FILENAME = "Gemfile.lock"

    def self.configuration
      @configuration ||= Pronto::BundlerAudit::Configuration.new
    end

    # @return [Array<Pronto::Message>] one for each issue found
    def run
      results = Auditor.call

      Pronto::BundlerAudit::Results::ProntoMessagesAdapter.call(
        results,
        self)
    end

    # @return [Pathname] the absolute path to the current git repo / code.
    def path
      Pathname.new(File.expand_path("."))
    end

    def filename
      GEMFILE_LOCK_FILENAME
    end

    # Don't really need a commit SHA for Pronto's GitHubFormatter to work. Just
    # need to return nil here, and in
    # {Pronto::BundlerAudit::Results::ProntoMessagesAdapter::DeepLine#commit_sha}.
    def commit_sha
      nil
    end
  end
end

require "pronto/bundler_audit/configuration"
require "pronto/bundler_audit/version"
require "pronto/bundler_audit/auditor"
require "pronto/bundler_audit/results/pronto_messages_adapter"
