# frozen_string_literal: true

require_relative "base_result"

module Pronto
  class BundlerAudit
    module Results
      # Pronto::BundlerAudit::Results::InsecureSource builds a Pronto::Message
      # for Bundler::Audit::Scanner::InsecureSource issues.
      class InsecureSource < BaseResult
        private

        def report_result
          build_message(
            message,
            line: nil,
            level: :warning)
        end

        def message
          "Insecure Source URI found: #{@scan_result.source}"
        end
      end
    end
  end
end
