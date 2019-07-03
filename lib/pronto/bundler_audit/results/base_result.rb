# frozen_string_literal: true

module Pronto
  class BundlerAudit
    module Results
      # Pronto::BundlerAudit::Results::BaseResult is an abstract base class for
      # the various Bundler::Audit::Scanner::* issue types.
      #
      # Note: These result objects act as a stand-in for ::Pronto::Message
      # objects, which are later translated into actual ::Pronto::Message
      # objects via {Pronto::BundlerAudit::MessagesAdapter}.
      class BaseResult
        def initialize(scan_result)
          @scan_result = scan_result
          @gem = scan_result.gem
          @advisory = scan_result.advisory
        end

        # @return [Symbol]
        def level
          raise NotImplementedError
        end

        # @return [Integer, NilClass]
        def line
          raise NotImplementedError
        end

        # @return [String]
        def message
          raise NotImplementedError
        end
      end
    end
  end
end
