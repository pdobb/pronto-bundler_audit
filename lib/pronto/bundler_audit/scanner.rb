# frozen_string_literal: true

require_relative "results/insecure_source"
require_relative "results/unpatched_gem"

module Pronto
  class BundlerAudit
    # Pronto::BundlerAudit::Scanner runs runs Bundler::Audit::Scanner#scan and
    # then instantiates and calls an appropriate
    # {Pronto::BundlerAudit::BaseResult} object for the given scan result type.
    class Scanner
      def self.call
        new.call
      end

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

      # Invoke the 3rd-party bundler-audit Gem.
      #
      # @return [Array] if insecure sources or if gems with an advisory are
      #   found, the Array will contain Bundler::Audit::Scanner::InsecureSource
      #   or Bundler::Audit::Scanner::UnpatchedGem objects, respectively.
      #   - Bundler::Audit::Scanner::InsecureSource = Struct.new(:source)
      #   - Bundler::Audit::Scanner::UnpatchedGem = Struct.new(:gem, :advisory)
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
