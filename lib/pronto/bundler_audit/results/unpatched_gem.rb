# frozen_string_literal: true

require_relative "base_result"
require "pronto/bundler_audit/advisory_formatters/compact"
require "pronto/bundler_audit/advisory_formatters/verbose"
require "pronto/bundler_audit/gemfile_lock/scanner"

module Pronto
  class BundlerAudit
    module Results
       class UnpatchedGem < BaseResult
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
