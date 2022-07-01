# frozen_string_literal: true

module Pronto
  class BundlerAudit
    module GemfileLock
      # Pronto::BundlerAudit::GemfileLock::Scanner scans the given `path` for
      # the given `gem_name` and returns an Integer representing the line number
      # of the gem in the Gemfile.lock file.
      class Scanner
        def initialize(gem_name, path = GEMFILE_LOCK_FILENAME)
          unless File.exist?(path)
            raise ArgumentError, "Gemfile.lock path not found"
          end

          @gem_name = gem_name
          @path = path
        end

        def self.call(*args)
          new(*args).call
        end

        def call
          determine_relevant_line_number
        end

        private

        # @return [Integer] the line number; or 0 if not found
        def determine_relevant_line_number
          line_number = 0

          File.foreach(@path).with_index do |line, index|
            next unless line.include?(@gem_name)

            line_number = index.next
            break
          end

          line_number
        end
      end
    end
  end
end
