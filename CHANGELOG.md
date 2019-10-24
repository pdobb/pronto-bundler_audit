### 0.5.1 - 2019-10-24
- Fix Pronto -> GitHub reporting errors
  - If Gemfile.lock is not in the PR then Pronto would fail when attempting to create a comment on the Gemfile.lock file withing the PR.
    - Note: This issue isn't fully fixed yet, but at least doesn't fail flat out.
      - To fully fix: would like to still add a PR-level comment with CVE issue(s) instead of requiring the user to dig into their CI output to see the CVE issue(s).

### 0.5.0 - 2019-07-31
- Fix Pronto -> GitHub reporting errors
  - Thanks to Inestor for the [bug report](https://github.com/pdobb/pronto-bundler_audit/issues/2).
  - Credit for the approach taken here goes to to os6sense and [his hard work](https://github.com/pdobb/pronto-bundler_audit/pull/4/files)

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
