# frozen_string_literal: true

require "pronto/bundler_audit/scanner"

module Pronto
  class BundlerAudit
    # Pronto::BundlerAudit::Auditor:
    # 1. Updates the local ruby security database, and then
    # 2. Runs {::Pronto::BundlerAudit::Scanner#call}.
    class Auditor
      def self.call(*args)
        new(*args).call
      end

      # @return (see: #run_scanner)
      def call
        update_ruby_advisory_db
        run_scanner
      end

      private

      def update_ruby_advisory_db
        Bundler::Audit::Database.update!(quiet: true)
      end

      # @return [Array<>] if no issues were found
      # @return [Array<Pronto::BundlerAudit::Results::BaseResult>] if unpatched
      #   gem sources or if advisories were found
      def run_scanner
        Scanner.call
      end
    end
  end
end
