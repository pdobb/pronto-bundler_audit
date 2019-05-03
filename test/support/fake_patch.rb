# frozen_string_literal: true

# FakePatch is a test double for Pronto::Git::Patch.
# https://github.com/prontolabs/pronto/blob/master/lib/pronto/git/patch.rb
class FakePatch
  attr_reader :additions

  def initialize(additions: 1, path: "test/path/Gemfile.lock")
    @additions = additions
    @path = path
  end

  def new_file_full_path
    @path
  end

  def added_lines
    [FakeLine.new]
  end

  class FakeLine
    def content
      "TEST_GEM_NAME"
    end

    def commit_sha
      "TEST_COMMIT_SHA"
    end
  end
end
