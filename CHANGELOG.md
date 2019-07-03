### Unreleased
- Fix: `NoMethodError: undefined method `position' for nil:NilClass` in /gems/pronto-0.10.0/lib/pronto/formatter/github_pull_request_review_formatter.rb:20:in `line_number'.
- [2](https://github.com/pdobb/pronto-bundler_audit/issues/2) Fix: `NoMethodError: undefined method `repo' for #<Pronto::BundlerAudit::GemfileLock::Scanner::Patch:...>`.

### 0.4.0 - 2019-05-08
- Remove patch-level processing... just always scan Gemfile.lock when this runner is invoked.

### 0.3.0 - 2019-05-03
- Internal rewrite into smaller objects with full test coverage
- Switch to using the verbose advisory formatter by default

### 0.2.1 - 2019-04-30
- Fix handling of the Pronto::Git::Patches collection in Pronto::BundlerAudit#run
- Ensure an Array is returned by Pronto::BundlerAudit#run, as expected by Pronto

### 0.2.0 - 2019-04-30
- Fix conditional for running Bundle Audit scans -- was always running even if there was nothing to run on in a given Pronto::Patches set

### 0.1.1 - 2019-04-29
- Add line number to Pronto::Message; fixes GitHub API usage error when attempting to add errors to PR comments
- Add gem version requirements to gemspec

### 0.1.0 - 2019-04-28
- Initial release!
