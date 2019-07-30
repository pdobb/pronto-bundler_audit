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

        def self.call(*args)
          new(*args).call
        end

        def call
          determine_line_number
        end

        private

        def determine_line_number
          File.foreach(@path).with_index do |line, index|
            break index.next if line.include?(@gem_name)
          end
        end
      end
    end
  end
end
