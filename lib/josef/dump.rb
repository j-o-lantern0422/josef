require "josef/google_workspace/client"
require "active_support"
require "active_support/core_ext"
module Josef
  module Dump
    include Josef::GoogleWorkspace::Client
    def remote_dump
      YAML.dump(remote.map{|h| h.deep_stringify_keys}, File.open('dump.yml', 'w'))
    end
  end
end
