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
          build_message(
            message,
            level: level,
            line: line)
        end

        # @return [::Pronto::Message] from `pronto` gem: lib/pronto/message.rb
        def build_message(message, level:, line:)
          ::Pronto::Message.new(
            GEMFILE_LOCK_FILENAME,
            line,
            level,
            message,
            nil,
            BundlerAudit) # From this gem: lib/pronto/bundler_audit.rb
        end

        def level
          raise NotImplementedError
        end

        def line
          raise NotImplementedError
        end

        def message
          raise NotImplementedError
        end
      end
    end
  end
end
