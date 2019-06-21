# frozen_string_literal: true

module Pronto
  class BundlerAudit
    module GemfileLock
      # Pronto::BundlerAudit::GemfileLock::Scanner scans the given `path` for
      # the given `gem_name` and returns a `Pronto::Git::Line` with relevant
      # info (supplied by Pronto::Git::Line and Pronto::Git::Patch stand-in
      # objects).
      #
      # We use stand-in objects because we don't have or need an actual
      # Pronto::Git::Line object. This is not a normal situation, but, for this
      # gem, we're not worried about specific details from git patches.
      # Instead, we just always scan the Gemfile.lock file for bundler_audit
      # issues/advisories.
      class Scanner
        def initialize(gem_name:, path: GEMFILE_LOCK_FILENAME)
          unless File.exist?(path)
            raise ArgumentError, "Gemfile.lock path not found"
          end

          @gem_name = gem_name
          @path = path
        end

        def call
          find_relevant_line
        end

        private

        # @return [Pronto::Git::Line]
        def find_relevant_line
          return unless (found_line_number = determine_line_number)

          build_pronto_git_line(found_line_number)
        end

        def determine_line_number
          File.foreach(@path).with_index do |line, index|
            break index.next if line.include?(@gem_name)
          end
        end

        # @return [Pronto::Git::Line]
        def build_pronto_git_line(line_number)
          ::Pronto::Git::Line.new(
            Line.new(line_number),
            Patch.new)
        end

        # Pronto::BundlerAudit::GemfileLock::Scanner::Line is a stand-in for
        # the Pronto::Git::Line object.
        class Line
          def initialize(line_number)
            @line_number = line_number
          end

          def new_lineno
            @line_number
          end
        end

        # Pronto::BundlerAudit::GemfileLock::Scanner::Patch is a stand-in for
        # the Pronto::Git::Patch object.
        class Patch
          def blame(*)
            nil
          end

          def repo(*)
            nil
          end
        end
      end
    end
  end
end
