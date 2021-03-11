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
  end
end
