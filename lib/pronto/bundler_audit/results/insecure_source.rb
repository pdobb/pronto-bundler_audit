# frozen_string_literal: true

require_relative "base_result"

module Pronto
  class BundlerAudit
    module Results
      class InsecureSource < BaseResult
        def initialize(scan_result)
          super(scan_result, level: :warning)

        end

        def call
          @message = "Insecure Source URI found: #{@scan_result.source}"
          super
        end
      end
    end
  end
end
