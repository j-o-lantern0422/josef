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

    def remote_apply(local)
      remote_diff(remote, local)
      local.each do | local_group |
        if be_create?(local_group)
          create_group(local_group[:group_mail_address])

          local_group[:members].each do | member |
            add_member(local_group[:group_mail_address], member)
          end
        elsif changed?(local_group)
          remote_members = remote.find{|g| g[:group_mail_address] == local_group[:group_mail_address]}[:members]

          add = local_group[:members] - remote_members
          del = remote_members - local_group[:members]

          add.each do | add_member_mail_address |
            add_member(local_group[:group_mail_address], add_member_mail_address)
          end

          del.each do | del_member_mail_address |
            del_member(local_group[:group_mail_address], del_member_mail_address)
          end
        end
      end

      remote.each do | remote_group |
        if be_delete?(remote_group)
          delete_group(remote_group[:group_mail_address])
        end
      end
    end
  end
end
