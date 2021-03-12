require "josef/google_workspace/client"
require "josef/remote"
require "josef/diff"
module Josef
  class Cli < Thor
    include Josef::GoogleWorkspace::Client
    include Josef::Remote
    include Josef::Diff
    class_option :dry_run, :type => :boolean, :default => false

    desc "dump", "dump google workspace group"
    def dump
      remote_dump
    end

    desc "diff [Path]", "print diff defferent local yaml and remote"
    method_options path: :string
    def diff(path)
      local(path)
      remote_diff(remote, local)
    end
  end
end
