# frozen_string_literal: true

require_relative "results/insecure_source"
require_relative "results/unpatched_gem"

module Pronto
  class BundlerAudit
    # Pronto::BundlerAudit::Scanner runs runs Bundler::Audit::Scanner#scan and
    # then calls a {Pronto::BundlerAudit::BaseResult} based for each scan
    # result.
    class Scanner
      # @return [Array>] if no advisories were found
      # @return [Array<Pronto::Message>] if advisories were found)
      def call
        run_scan
      end

      private

      def run_scan
        run_scanner.map do |scan_result|
          match_result(scan_result).call
        end
      end

      def run_scanner
        Bundler::Audit::Scanner.new.scan
      end

      def match_result(scan_result)
        case scan_result
        when Bundler::Audit::Scanner::InsecureSource
          Results::InsecureSource.new(scan_result)
        when Bundler::Audit::Scanner::UnpatchedGem
          Results::UnpatchedGem.new(scan_result)
        else
          raise ArgumentError, "Unexpected type: #{scan_result.class}"
        end
      end
    end
  end
end
