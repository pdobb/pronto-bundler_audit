# frozen_string_literal: true

require_relative "base_advisory_formatter"

module Pronto
  class BundlerAudit
    module AdvisoryFormatters
      # Pronto::BundlerAudit::AdvisoryFormatters::Compact is a compact message
      # formatter for the given gem object and Bundler::Audit::Advisory#advisory
      # object.
      class Compact < BaseAdvisoryFormatter
        def to_s
          [
            "Gem: #{gem_name} v#{gem_version}",
            "#{advisory_criticality} Advisory: #{advisory_title} -- "\
              "#{advisory_description} (#{advisory_url})",
            "Solution: #{advisory_solution}"
          ].join(" | ")
        end
      end
    end
  end
end
