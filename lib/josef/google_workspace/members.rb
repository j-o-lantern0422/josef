module Josef
  module GoogleWorkspace
    module Members
      def member_mail_addreses(group)
        members_by(group).map do | member |
          member.email
        end
      end

      def members_by(group)
        client.list_members(group.id).members
      end
    end
  end
end
