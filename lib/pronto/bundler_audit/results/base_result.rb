# frozen_string_literal: true

module Pronto
  class BundlerAudit
    module Results
      # Pronto::BundlerAudit::Results::BaseResult is an abstract base class for
      # the various Bundler::Audit::Scanner::* issue types.
      class BaseResult
        def initialize(scan_result)
          @scan_result = scan_result
          @gem = scan_result.gem
          @advisory = scan_result.advisory
        end

        def call
          report_result
        end

        private

        def report_result
          raise NotImplementedError
        end

        def build_message(message, level:, line:)
          Message.new(
            GEMFILE_LOCK_FILENAME,
            line,
            level,
            message,
            nil,
            Pronto::BundlerAudit)
        end

        def message
          raise NotImplementedError
        end
      end
    end
  end
end
