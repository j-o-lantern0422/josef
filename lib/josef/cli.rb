require "josef/google_workspace/client"
require "josef/dump"
module Josef
  class Cli < Thor
    include Josef::GoogleWorkspace::Client
    include Josef::Remote
    class_option :dry_run, :type => :boolean, :default => false

    desc "dump", "dump google workspace group"
    def dump
      remote_dump
    end

    desc "diff [Path]", "print diff defferent local yaml and remote"
    method_options path: :string
    def diff(path)
      local = YAML.load_file(path)
      remote_diff(remote_dump, local)
    end
  end
end
