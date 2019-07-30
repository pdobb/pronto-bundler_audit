# frozen_string_literal: true

module Pronto
  class BundlerAudit
    module Results
      # Classes for the various issue types. Rather than attempt to convert to
      # a pronto message deep within the class hierarchy, we return our own
      # result type which we can then manipulate as neccessary when putting
      # a result set together for pronto.
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
          self
        end
      end
    end
  end
end
