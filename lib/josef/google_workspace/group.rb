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
    end
  end
end


