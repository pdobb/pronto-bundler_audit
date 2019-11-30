# frozen_string_literal: true

module Pronto
  class BundlerAudit
    # Pronto::BundlerAudit::Configuration loads configuration for the
    # pronto-bundler_audit gem from the `.pronto-bundler_audit.yml` file and
    # provides service methods for reading configuration settings.
    class Configuration
      def initialize(path: ".pronto-bundler_audit.yml")
        @config_file_path = path
      end

      # @return [Array<Sring>] the Advisory Names for bundler_audit to ignore
      def ignored_advisories
        configuration.dig("Advisories", "Ignore")
      end

      private

      def configuration
        @configuration ||=
          if File.exist?(@config_file_path)
            YAML.load(configuration_file.read)
          else
            {}
          end
      end

      def configuration_file
        File.open(@config_file_path)
      end
    end
  end
end
