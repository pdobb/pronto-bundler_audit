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
