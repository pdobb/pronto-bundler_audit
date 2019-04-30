# FakPatch is a test double for Pronto::Git::Patch.
# https://github.com/prontolabs/pronto/blob/master/lib/pronto/git/patch.rb
class FakePatch
  def initialize(additions: 1, path: "test/path/Gemfile.lock")
    @additions = additions
    @path = path
  end

  def additions
    @additions
  end

  def new_file_full_path
    @path
  end
end
