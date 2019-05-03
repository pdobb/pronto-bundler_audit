# FakeAdvisory is a test double for Bundler::Audit::Advisory
class FakeAdvisory
  def cve
    "TEST_CVE"
  end

  def osvdb
    "TEST_OSVDB"
  end

  def criticality
    "TEST_CRITICALITY"
  end

  def url
    "TEST_URL"
  end

  def title
    "TEST_TITLE"
  end

  def patched_versions
    ["TEST_PATCHED_VERSION1"]
  end
end
