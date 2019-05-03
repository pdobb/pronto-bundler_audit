# frozen_string_literal: true

require_relative "base_advisory_formatter"

module Pronto
  class BundlerAudit
    module AdvisoryFormatters
      # Pronto::BundlerAudit::AdvisoryFormatters::Verbose is a verbose message
      # formatter for the given gem object and Bundler::Audit::Advisory#advisory
      # object.
      class Verbose < BaseAdvisoryFormatter
        def to_s
          [
            "Name: #{gem_name}",
            "Version: #{gem_version}",
            "Advisory: #{advisory_description}",
            "Criticality: #{advisory_criticality}",
            "URL: #{advisory_url}",
            "Title: #{advisory_title}",
            "Solution: #{advisory_solution}"
          ].join("\n")
        end
      end
    end
  end
end
