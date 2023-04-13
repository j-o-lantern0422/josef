module Josef
  module GoogleWorkspace
    module Members
      def member_mail_addreses(group)
        members_by(group)&.map do | member |
          member.email
        end
      end

      def members_by(group)
        res = client.list_members(group.id)
        members = res.members
        next_page_token = res.next_page_token
        while next_page_token.nil?.!
          res = client.list_members(group.id, page_token: next_page_token)
          next_page_token = res.next_page_token
          members.concat(res.members)
        end

        members || []
      end

      def add_member(group_mail_address, member_mail_address)
        member = ::Google::Apis::AdminDirectoryV1::Member.new(email: member_mail_address)
        group = groups.find{|g| g.email == group_mail_address}
        client.insert_member(group.id, member)
      rescue => e
        $stderr.puts "Failed to add #{member_mail_address} to #{group_mail_address} group. #{e}"
      end

      def del_member(group_mail_address, member_mail_address)
        group = groups.find{|g| g.email == group_mail_address}
        member = members_by(group).find{ |member| member.email == member_mail_address }
        client.delete_member(group.id, member.id)
      rescue => e
        $stderr.puts "Failed to remove #{member_mail_address} from #{group_mail_address} group. #{e}"
      end
    end
  end
end
