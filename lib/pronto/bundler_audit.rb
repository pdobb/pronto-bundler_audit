require "pronto"
require "bundler/audit/database"
require "bundler/audit/scanner"

module Pronto
  # Pronto::BundlerAudit is a Pronto::Runner that:
  # 1. Finds the most relevant patch (the last patch that contains a change to
  #    Gemfile.lock)
  # 2. Updates the Ruby Advisory Database
  # 3. Runs bundle-audit to scan the Gemfile.lock
  # 4. Returns an Array of Pronto::Message objects if any advisories are found
  class BundlerAudit < Runner
    GEMFILE_LOCK_FILENAME = "Gemfile.lock".freeze

    # @return [Array] per Pronto expectation
    def run
      if (patch = find_relevant_patch)
        auditor = Auditor.new(patch)
        auditor.call
      else
        []
      end
    end

    private

    def find_relevant_patch
      @patches.to_a.reverse.detect { |patch|
        patch.additions > 0 && relevant_patch_path?(patch)
      }
    end

    def relevant_patch_path?(patch)
      patch_path = patch.new_file_full_path.to_s
      patch_path.end_with?(GEMFILE_LOCK_FILENAME)
    end
  end
end

require "pronto/bundler_audit/version"
require "pronto/bundler_audit/auditor"
