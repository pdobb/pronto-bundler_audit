# frozen_string_literal: true

require "pronto"
require "bundler/audit/database"
require "bundler/audit/scanner"

module Pronto
  # Pronto::BundlerAudit is a Pronto::Runner that:
  # 1. Updates the Ruby Advisory Database,
  # 2. Runs bundle-audit to scan the Gemfile.lock, and then
  # 3. Returns an Array of Pronto::Message objects if any issues or advisories
  # are found.
  class BundlerAudit < Runner
    GEMFILE_LOCK_FILENAME = "Gemfile.lock"

    # @return [Array<Pronto::Message>] per Pronto expectation
    def run
      results = Auditor.new.call
      return [] unless results && results.size > 0

      Results::Converter
        .new(results, @patches.commit, @patches.repo.path)
        .call
    end
  end
end

require "pronto/bundler_audit/version"
require "pronto/bundler_audit/auditor"
require "pronto/bundler_audit/results/converter"
