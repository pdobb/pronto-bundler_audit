# frozen_string_literal: true

require "pronto/bundler_audit/advisory_formatters/compact"
require "pronto/bundler_audit/advisory_formatters/verbose"
require "pronto/bundler_audit/gemfile_lock/scanner"

module Pronto
  class BundlerAudit
    module Results
      # Classes for the various issue types. Rather than attempt to convert to
      # a pronto message deep within the class hierarchy, we return our own
      # result type which we can then manipulate as neccessary when putting
      # a result set together for pronto.
      class Result
        attr_reader :line, :level, :message

        def initialize(scan_result, level: :error)
          @scan_result = scan_result
          @gem = scan_result.gem
          @advisory = scan_result.advisory

          @level = level
          @line = nil
        end

        def call
          self
        end
      end

      class InsecureSource < Result
        def initialize(scan_result)
          super(scan_result, level: :warning)

          @message = "Insecure Source URI found: #{@scan_result.source}"
        end
      end

      class UnpatchedGem < Result
        # TODO: Switch AdvisoryFormatters type based on configuration options, once available.
        def call
          @line = GemfileLock::Scanner.call(gem_name: @gem.name)
          @message = AdvisoryFormatters::Verbose.new(gem: @gem, advisory: @advisory).to_s
          super
        end
      end
    end
  end
end
