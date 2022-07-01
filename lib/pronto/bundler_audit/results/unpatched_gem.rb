# frozen_string_literal: true

require_relative "base_result"
require "pronto/bundler_audit/advisory_formatters/compact"
require "pronto/bundler_audit/advisory_formatters/verbose"
require "pronto/bundler_audit/gemfile_lock/scanner"

module Pronto
  class BundlerAudit
    module Results
      # Pronto::BundlerAudit::Results::UnpatchedGem is a stand-in for the
      # ::Pronto::Message object for ::Bundler::Audit::Scanner::UnpatchedGem
      # issues.
      class UnpatchedGem < BaseResult
        # @return [Symbol]
        def level
          :error
        end

        # @return [Integer]
        def line
          find_relevant_line_number
        end

        # @return [String]
        def message
          advisory_formatter.to_s
        end

        private

        # @return [Integer]
        def find_relevant_line_number
          Pronto::BundlerAudit::GemfileLock::Scanner.call(@gem.name)
        end

        def advisory_formatter
          # TODO: Switch type based on configuration options, once available.
          Pronto::BundlerAudit::AdvisoryFormatters::Verbose.new(
            @gem,
            @advisory)
        end
      end
    end
  end
end
