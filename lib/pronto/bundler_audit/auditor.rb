require "pronto/bundler_audit/scanner"

module Pronto
  class BundlerAudit
    # Pronto::BundlerAudit::Auditor:
    # 1. updates the local ruby security database, and then
    # 2. runs {Pronto::BundlerAudit::Scanner#call} on the given `patch`.
    class Auditor
      def initialize(patch)
        @patch = patch
      end

      # @return (see: #run_scan)
      def call
        update_ruby_advisory_db
        run_scanner
      end

      private

      def update_ruby_advisory_db
        Bundler::Audit::Database.update!(quiet: true)
      end

      # @return [Array>] if no advisories were found
      # @return [Array<Pronto::Message>] if advisories were found
      def run_scanner
        scanner = Scanner.new(@patch)
        scanner.call
      end
    end
  end
end
