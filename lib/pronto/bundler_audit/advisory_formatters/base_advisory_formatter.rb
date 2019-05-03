# frozen_string_literal: true

module Pronto
  class BundlerAudit
    module AdvisoryFormatters
      # Pronto::BundlerAudit::AdvisoryFormatters::BaseAdvisoryFormatter is an
      # abstract base class for formatting Bundler::Audit::Advisory objects
      # as a String in the context of the given `gem`
      # (Bundler::LazySpecification).
      class BaseAdvisoryFormatter
        # param gem [Bundler::LazySpecification]
        # param advisory [Bundler::Audit::Advisory]
        def initialize(gem:, advisory:)
          @gem = gem
          @advisory = advisory
        end

        def to_s
          raise NotImplementedError
        end

        private

        def gem_name
          @gem.name
        end

        def gem_version
          @gem.version
        end

        def advisory_description
          if @advisory.cve
            "CVE-#{@advisory.cve}"
          elsif @advisory.osvdb
            @advisory.osvdb
          end
        end

        def advisory_criticality
          str = @advisory.criticality.to_s.capitalize
          str = "Unknown" if str.empty?
          str
        end

        def advisory_url
          @advisory.url
        end

        def advisory_title
          @advisory.title
        end

        def advisory_solution
          if any_patched_versions?
            "Upgrade to #{patched_versions}."
          else
            "Remove or disable this gem until a patch is available!"
          end
        end

        def patched_versions
          @advisory.patched_versions.join(", ")
        end

        def any_patched_versions?
          !@advisory.patched_versions.empty?
        end
      end
    end
  end
end
