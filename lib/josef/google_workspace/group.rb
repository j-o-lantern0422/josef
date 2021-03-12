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

      def create_group(group_mail_address)
        group = ::Google::Apis::AdminDirectoryV1::Group.new(email: group_mail_address)

        client.insert_group(group)
      end

      def delete_group(group_mail_address)
        group = groups.find{|g| g.email == group_mail_address}

        client.delete_group(group.id)
      end
    end
  end
end


