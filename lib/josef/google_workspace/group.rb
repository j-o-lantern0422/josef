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
          res = client.list_groups(domain: domain)
          domain_groups = res.groups
          next_page_token = res.next_page_token

          while next_page_token.nil?.!
            res = client.list_groups(domain: domain, page_token: next_page_token)
            next_page_token = res.next_page_token
            domain_groups.concat(res.groups)
          end

          domain_groups
        end.flatten.compact
      end

      def create_group(group_mail_address)
        group = ::Google::Apis::AdminDirectoryV1::Group.new(email: group_mail_address)

        client.insert_group(group)
        @_groups = nil
      end

      def delete_group(group_mail_address)
        group = groups.find{|g| g.email == group_mail_address}

        client.delete_group(group.id)
        @_groups = nil
      end
    end
  end
end
