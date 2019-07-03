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

        def level
          :error
        end

        def line
          find_relevant_line
        end

        def find_relevant_line
          GemfileLock::Scanner.call(gem_name: @gem.name)
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
