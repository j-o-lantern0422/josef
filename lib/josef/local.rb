require "josef/google_workspace/client"
require "active_support"
require "active_support/core_ext"
module Josef
  module Local
    def local(local_file = nil)
      @_local ||= local!(local_file)
    end

    def local!(local_file)
      return [] if local_file.nil?

      local_groups = YAML.load_file(local_file).map{|h| h.deep_symbolize_keys}
      local_groups.each do | group |
        group[:members] = [] if group[:members].nil?
      end

      local_groups
    end

    def exculued?(group_mail_address)
      exculued_groups.include?(group_mail_address)
    end

    def exculued_groups(exculued_groups_file = nil)
      @_exculued_groups ||= exculued_groups!(exculued_groups_file)
    end

    def exculued_groups!(exculued_groups_file)
      return [] if exculued_groups_file.nil?

      YAML.load_file(exculued_groups_file).symbolize_keys[:exculued_groups]
    end
  end
end
