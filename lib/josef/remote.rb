require "josef/google_workspace/client"
require "active_support"
require "active_support/core_ext"
module Josef
  module Remote
    include Josef::GoogleWorkspace::Client
    def remote_dump
      YAML.dump(remote.map{|h| h.deep_stringify_keys}, File.open('dump.yml', 'w'))
    end

    def changed?(local_group)
      remote_dump.find(group_mail_address: local_group[:group_mail_address])
    end

    def be_create?(local_group)
      remote_dump.find(group_mail_address: local_group[:group_mail_address])
    end

    def remote_diff(remote_dump, local)
      local.each do | local_group |
        if group_exist?(local_group[:group_mail_address])
          remote_members = remote_dump.find(group_mail_address: local_group[:group_mail_address])
          add = local_group[:members] - remote_members
          del = remote_members - local_group[:members]
          if add.empty? && del.empty?
            next
          end
        end
      end
    end

    def group_exist?(local_group_email)
      remote_dump.each do | group |
        return true if group[:group_mail_address] == local_group_email
      end

      false
    end
  end
end
