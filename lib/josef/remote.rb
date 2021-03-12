require "josef/google_workspace/client"
require "josef/google_workspace/group"
require "active_support"
require "active_support/core_ext"
module Josef
  module Remote
    include Josef::GoogleWorkspace::Client
    include Josef::GoogleWorkspace::Group
    def remote
      @_remote ||= remote!
    end

    def remote!
      groups.map do | group |
        { group_mail_address: group.email, members: member_mail_addreses(group) }
      end
    end

    def remote_dump
      YAML.dump(remote.map{|h| h.deep_stringify_keys}, File.open('dump.yml', 'w'))
    end
  end
end
