require "josef/remote"
require "josef/local"
module Josef
  module Diff
    include Josef::Remote
    include Josef::Local
    def changed?(local_group)
      remote_group = remote.find{|g| g[:group_mail_address] == local_group[:group_mail_address]}
      return false if local_group[:members].nil? || remote_group[:members].nil?
      return false if local_group[:members].sort == remote_group[:members].sort

      true
    end

    def be_create?(local_group)
      remote.find{|g| g[:group_mail_address] == local_group[:group_mail_address]}.nil?
    end

    def be_delete?(remote_group)
      local.find{|g| g[:group_mail_address] == remote_group[:group_mail_address]}.nil?
    end

    def remote_diff(remote, local, mode = "apply")
      local.each do | local_group |
        if be_create?(local_group)
          puts "#{local_group[:group_mail_address]} will be create:#{mode}"
          local_group[:members].each do | member |
            puts "+ #{member}"
          end
        elsif changed?(local_group)
          puts "#{local_group[:group_mail_address]} will be change:#{mode}"
          remote_members = remote.find{|g| g[:group_mail_address] == local_group[:group_mail_address]}[:members]

          add = local_group[:members] - remote_members
          del = remote_members - local_group[:members]

          add.each do | add_member |
            puts "+ #{add_member}"
          end

          del.each do | del_member |
            puts "- #{del_member}"
          end
        end
      end

      remote.each do | remote_group |
        if be_delete?(remote_group)
          puts "#{remote_group[:group_mail_address]} will be delete:#{mode}"
        end
      end
    end
  end
end
