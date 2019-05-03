# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pronto/bundler_audit/version"

Gem::Specification.new do |spec|
  spec.name          = "pronto-bundler_audit"
  spec.version       = Pronto::BundlerAuditVersion::VERSION
  spec.authors       = ["Paul Dobbins"]
  spec.email         = ["paul.dobbins@icloud.com"]

  spec.summary       =
    "Pronto runner for bundler-audit, patch-level verification for bundler."
  spec.homepage      = "http://github.com/pdobb/pronto-bundler_audit"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f|
      f.match(%r{^(test|spec|features)/})
    }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bundler-audit", "~> 0"
  spec.add_runtime_dependency "pronto", "~> 0"

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "byebug", "~> 11"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "minitest-reporters", "~> 1"
  spec.add_development_dependency "much-stub", "~> 0"
  spec.add_development_dependency "pry", "~> 0"
  spec.add_development_dependency "pry-byebug", "~> 3"
  spec.add_development_dependency "rake", "~> 12"
  spec.add_development_dependency "rubocop", ">= 0.67.2", "< 1"
  spec.add_development_dependency "simplecov", "~> 0.16"
end
