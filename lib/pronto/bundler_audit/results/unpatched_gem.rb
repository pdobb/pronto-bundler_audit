# frozen_string_literal: true

require_relative "base_result"
require "pronto/bundler_audit/advisory_formatters/compact"
require "pronto/bundler_audit/advisory_formatters/verbose"
require "pronto/bundler_audit/gemfile_lock/scanner"

module Pronto
  class BundlerAudit
    module Results
      # Pronto::BundlerAudit::Results::UnpatchedGem builds a Pronto::Message for
      # Bundler::Audit::Scanner::UnpatchedGem issues.
      class UnpatchedGem < BaseResult
        private

        def report_result
          build_message(
            message,
            level: :error,
            line: find_relevant_line)
        end

        def find_relevant_line
          scanner = GemfileLock::Scanner.new(gem_name: @gem.name)
          scanner.call
        end

        def message
          advisory_formatter.to_s
        end

        def advisory_formatter
          # TODO: Switch type based on configuration options, once available.
          AdvisoryFormatters::Verbose.new(gem: @gem, advisory: @advisory)
        end
      end
    end
  end
end
