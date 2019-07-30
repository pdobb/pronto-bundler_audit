# frozen_string_literal: true

module Pronto
  class BundlerAudit
    module Results
      # Takes [Array<Pronto::BundlerAudit::Results::Result] and returns
      # [Array<Pronto::Message>]
      class Converter
        def initialize(results, commit, path)
          @results = results
          @commit = commit
          @path = path
        end

        def call
          @results.map do |result|
            ::Pronto::Message.new(GEMFILE_LOCK_FILENAME,
                                  DeepLine.new(result.line, @path),
                                  result.level,
                                  result.message,
                                  @commit,
                                  BundlerAudit)
          end
        end
      end

      # This piece of ugliness is here due to prontos message handling, its a bit
      # of a mess in there and rather than deal with wrapping it, we create a class
      # to supply it with what it really wants i.e. line_number and repo path.
      class DeepLine
        attr_reader :line_number, :path

        def initialize(line_number, path)
          @path = path
          @line_number = line_number
        end

        alias :repo :itself
        alias :patch :itself
        alias :new_lineno :line_number
      end
      private_constant :DeepLine
    end
  end
end
