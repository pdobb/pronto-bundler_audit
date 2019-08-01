# frozen_string_literal: true

require_relative "base_result"

module Pronto
  class BundlerAudit
    module Results
      # Pronto::BundlerAudit::Results::InsecureSource is a stand-in for the
      # ::Pronto::Message object for ::Bundler::Audit::Scanner::InsecureSource
      # issues.
      class InsecureSource < BaseResult
        # @return [Symbol]
        def level
          :warning
        end

        # @return [NilClass]
        def line
          nil
        end

        # @return [String]
        def message
          "Insecure Source URI found: #{@scan_result.source}"
        end
      end
    end
  end
end
