require "josef/google_workspace/config"
require "josef/google_workspace/members"
module Josef
  module GoogleWorkspace
    module Group
      include Josef::GoogleWorkspace::Config
      include Josef::GoogleWorkspace::Members
      def groups
        @_groups ||= groups!
      end

      def groups!
        domains.map do | domain |
          client.list_groups(domain: domain).groups
        end.flatten.compact
      end

      def remote
        @_remote ||= remote!
      end

      def remote!
        groups.map do | group |
          { group_mail_address: group.email, members: member_mail_addreses(group) }
        end
      end
    end
  end
end


