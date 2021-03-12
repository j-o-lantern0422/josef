require "josef/google_workspace/client"
require "active_support"
require "active_support/core_ext"
module Josef
  module Local
    def local(local_file = nil)
      @_local ||= local!(local_file)
    end

    def local!(local_file)
      YAML.load_file(local_file).map{|h| h.deep_symbolize_keys}
    end
  end
end
