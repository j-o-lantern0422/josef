require "josef/google_workspace/client"
module Josef
  class Cli < Thor
    include Josef::GoogleWorkspace::Client

    class_option :dry_run, :type => :boolean, :default => false

    desc "dump", "dump google workspace group"
    def dump
      binding.irb

      p client
    end
  end
end
