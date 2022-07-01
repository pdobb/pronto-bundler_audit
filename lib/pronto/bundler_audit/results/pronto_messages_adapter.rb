# frozen_string_literal: true

module Pronto
  class BundlerAudit
    module Results
      # Pronto::BundlerAudit::Results::ProntoMessagesAdapter is an adapter layer
      # for converting {Pronto::BundlerAudit::BaseResult} objects into
      # ::Pronto::Message objects for use by the Pronto gem when sending issue
      # details to GitHub, etc.
      class ProntoMessagesAdapter
        def initialize(results, runner)
          @results = Array(results)
          @runner = runner
        end

        def self.call(*args)
          new(*args).call
        end

        def call
          @results.map { |result|
            ::Pronto::Message.new(
              @runner.filename,
              DeepLine.new(result.line, @runner.path),
              result.level,
              result.message,
              @runner.commit_sha,
              Pronto::BundlerAudit) # This gem's {Pronto::BundlerAudit} class.
          }
        end

        # Pronto::BundlerAudit::Results::ProntoMessagesAdapter::DeepLine is a
        # stand-in for ::Pronto::Git::Line object.
        class DeepLine
          attr_reader :line_number,
                      :path

          def initialize(line_number, path)
            @line_number = line_number
            @path = path
          end

          # Since we're not passing a commit SHA into ::Pronto::Message.new,
          # Pronto will try calling #commit_sha on the (this) Line object.
          def commit_sha
            nil
          end

          def line
            self
          end

          alias_method :new_lineno, :line_number
          alias_method :repo, :itself
          alias_method :patch, :itself
        end
      end
    end
  end
end
