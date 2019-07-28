# frozen_string_literal: true

require "pronto/bundler_audit/advisory_formatters/compact"
require "pronto/bundler_audit/advisory_formatters/verbose"
require "pronto/bundler_audit/gemfile_lock/scanner"

module Pronto
  class BundlerAudit
    module Results
      # Classes for the various issue types.
      class BaseResult
        attr_reader :line, :level, :message

        def initialize(scan_result, level: :error)
          @scan_result = scan_result
          @gem = scan_result.gem
          @advisory = scan_result.advisory

          @level = level
          @line = nil
        end

        def call
          @line ||= GemfileLock.new(gem_name: @gem.name).scan

           # TODO: Switch type based on configuration options, once available.
          @message = AdvisoryFormatters::Verbose.new(gem: @gem, advisory: @advisory).to_s

           self
        end
       end

      class InsecureSource < BaseResult
        def initialize(scan_result)
          super(scan_result, level: :warning)

          @message = "Insecure Source URI found: #{@scan_result.source}"
        end

        def call
          self
        end
      end

      UnpatchedGem = Class.new(BaseResult)
    end
  end
end
