# frozen_string_literal: true

require_relative "results/insecure_source"
require_relative "results/unpatched_gem"
require "yaml"

module Pronto
  class BundlerAudit
    # Pronto::BundlerAudit::Scanner runs runs Bundler::Audit::Scanner#scan and
    # then instantiates and calls an appropriate
    # {Pronto::BundlerAudit::BaseResult} object for the given scan result type.
    class Scanner
      def self.call(*args)
        new(*args).call
      end

      # @return [Array<>] if no issues were found
      # @return [Array<Pronto::BundlerAudit::Results::BaseResult>] if unpatched
      #   gem sources or if advisories were found
      def call
        run_scan
      end

      private

      # @return [Array<>] if no issues were found
      # @return [Array<Pronto::BundlerAudit::Results::BaseResult>]
      def run_scan
        run_scanner.map do |scan_result|
          match_result(scan_result)
        end
      end

      # Invoke the 3rd-party bundler-audit Gem.
      #
      # @param ignore_advisories [Array<String>] the advisories to be ignored
      #   by the bundler_audit scan
      #
      # @return [Array] if insecure sources are found or if gems with an
      #   advisory are found, the Array will contain
      #   ::Bundler::Audit::Scanner::InsecureSource
      #   or ::Bundler::Audit::Scanner::UnpatchedGem objects, respectively.
      #     - Bundler::Audit::Scanner::InsecureSource = Struct.new(:source)
      #     - Bundler::Audit::Scanner::UnpatchedGem = Struct.new(:gem, :advisory)
      def run_scanner(
            ignored_advisories:
              Pronto::BundlerAudit.configuration.ignored_advisories)
        ::Bundler::Audit::Scanner.new.scan(ignore: ignored_advisories)
      end

      # Convert the passed in `scan_result` class/value into a local Results::*
      # class/value.
      #
      # @param scan_result [::Bundler::Audit::Scanner::*] from the bundler-audit
      #   Gem
      #
      # @return [Pronto::BundlerAudit::Results::BaseResult]
      def match_result(scan_result)
        case scan_result
        when ::Bundler::Audit::Scanner::InsecureSource
          Results::InsecureSource.new(scan_result)
        when ::Bundler::Audit::Scanner::UnpatchedGem
          Results::UnpatchedGem.new(scan_result)
        else
          raise ArgumentError, "Unexpected type: #{scan_result.class}"
        end
      end
    end
  end
end
