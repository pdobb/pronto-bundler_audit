# frozen_string_literal: true

require "pronto"
require "bundler/audit/database"
require "bundler/audit/scanner"
require 'pry'

module Pronto
  # Pronto::BundlerAudit is a Pronto::Runner that:
  # 1. Updates the Ruby Advisory Database,
  # 2. Runs bundle-audit to scan the Gemfile.lock, and then
  # 4. Returns an Array of Pronto::Message objects if any issues or advisories
  # are found.
  class BundlerAudit < Runner
    GEMFILE_LOCK_FILENAME = "Gemfile.lock"

    # @return [Array<Pronto::Message>] per Pronto expectation
    def run
      results = Auditor.new.call
      binding.pry
      results

      return results unless results.size > 0

      results.map do |result|
        Message.new(GEMFILE_LOCK_FILENAME,
                    DeepLine.new(result.line, @patches.repo.path),
                    result.level,
                    result.message,
                    @patches.commit,
                    self.class)
      end
    end
  end

  # This piece of ugliness is here due to prontos message handling, its a bit
  # of a mess in there and rather than deal with wrapping it, we create a class
  # to supply it with what it wants i.e. line_number and path.
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
end

require "pronto/bundler_audit/version"
require "pronto/bundler_audit/auditor"
