require "pronto"
require "bundler/audit/database"
require "bundler/audit/scanner"

module Pronto
  # Pronto::BundlerAudit is a Pronto::Runner that:
  # 1. Finds the most relevant patch (the last patch that contains a change to
  #    Gemfile.lock)
  # 2. Updates the Ruby Advisory Database
  # 3. Runs bundle-audit to scan the Gemfile.lock
  # 4. Returns an Array of Pronto::Message objects if any advisories are found
  class BundlerAudit < Runner
    GEMFILE_LOCK_FILENAME = "Gemfile.lock".freeze

    def run
      patch = find_relevant_patch

      patch_handler = PatchHandler.new(patch, runner: self)
      patch_handler.call
    end

    private

    def find_relevant_patch
      @patches.reverse_each { |patch|
        break patch if patch.additions > 0 && relevant_patch_path?(patch)
      }
    end

    def relevant_patch_path?(patch)
      patch_path = patch.new_file_full_path.to_s
      patch_path.end_with?(GEMFILE_LOCK_FILENAME)
    end

    # Pronto::BundlerAudit::PatchHandler runs Bundle Audit on the given patch
    # and returns an Array of Pronto::Message objects if any advisories are
    # found.
    class PatchHandler
      def initialize(patch, runner:)
        @patch = patch
        @runner = runner
      end

      # @return (see: #run_scan)
      def call
        update_ruby_advisory_db
        run_scan
      end

      private

      def update_ruby_advisory_db
        Bundler::Audit::Database.update!(quiet: true)
      end

      # @return [Array>] if no advisories were found
      # @return [Array<Pronto::Message>] if advisories were found
      def run_scan
        scanner = Bundler::Audit::Scanner.new

        scanner.scan.inject([]) do |acc, scan_result|
          acc << process_scan_result(scan_result)
        end
      end

      def process_scan_result(scan_result)
        case scan_result
        when Bundler::Audit::Scanner::InsecureSource
          report_insecure_source_scan_result
        when Bundler::Audit::Scanner::UnpatchedGem
          report_unpatched_gem_scan_result(scan_result)
        end
      end

      def report_insecure_source_scan_result(scan_result)
        build_warning_message(
          "Insecure Source URI found: #{scan_result.source}")
      end

      def report_unpatched_gem_scan_result(scan_result)
        advisory =
          AdvisoryFormatter.new(
            gem: scan_result.gem, advisory: scan_result.advisory)
        message = advisory.to_compact_s
        line = find_relevant_line(advisory)

        build_error_message(message, line: line)
      end

      # @return [Pronto::Git::Line]
      def find_relevant_line(advisory)
        first_added_line_for_affected_gem_name(advisory.gem_name)
      end

      # @return [Pronto::Git::Line]
      def first_added_line_for_affected_gem_name(gem_name)
        @patch.added_lines.detect { |line| line.content.include?(gem_name) }
      end

      def build_warning_message(message)
        build_message(message, level: :warning)
      end

      def build_error_message(message, line:)
        build_message(message, level: :error, line: line)
      end

      def build_message(message, level:, line:)
        Message.new(
          GEMFILE_LOCK_FILENAME, line, level, message, nil, @runner.class)
      end

      # Pronto::BundlerAudit::PatchHandler::AdvisoryFormatter is a message
      # formatter for the given gem object and Bundler::Audit::Advisory#advisory
      # object.
      class AdvisoryFormatter
        # param gem [Bundler::LazySpecification]
        # param advisory [Bundler::Audit::Advisory]
        def initialize(gem:, advisory:)
          @gem = gem
          @advisory = advisory
        end

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

        def to_compact_s
          [
            "Gem: #{gem_name} v#{gem_version}",
            "#{advisory_criticality} Advisory: #{advisory_title} -- "\
              "#{advisory_description} (#{advisory_url})",
            "Solution: #{advisory_solution}"
          ].join(" | ")
        end

        def gem_name
          @gem.name
        end

        private

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
          @advisory.patched_versions.join(', ')
        end

        def any_patched_versions?
          !@advisory.patched_versions.empty?
        end
      end
    end
  end
end
