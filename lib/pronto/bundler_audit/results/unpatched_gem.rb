# frozen_string_literal: true

require_relative "base_result"
require "pronto/bundler_audit/advisory_formatters/verbose"
require "pronto/bundler_audit/advisory_formatters/compact"

module Pronto
  class BundlerAudit
    module Results
      # Pronto::BundlerAudit::Results::UnpatchedGem builds a Pronto::Message for
      # Bundler::Audit::Scanner::UnpatchedGem issues.
      class UnpatchedGem < BaseResult
        def initialize(scan_result, patch:)
          super(scan_result)
          @patch = patch
        end

        private

        def report_result
          build_message(
            message,
            level: :error,
            line: find_relevant_line)
        end

        # @return [Pronto::Git::Line]
        def find_relevant_line
          first_added_line_for_affected_gem_name(@gem.name)
        end

        # @return [Pronto::Git::Line]
        def first_added_line_for_affected_gem_name(gem_name)
          @patch.added_lines.detect { |line| line.content.include?(gem_name) }
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
