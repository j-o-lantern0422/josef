require "josef/google_workspace/config"
module Josef
  module GoogleWorkspace
    module Group
      include Josef::GoogleWorkspace::Config
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


