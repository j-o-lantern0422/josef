require "yaml"
module Josef
  module GoogleWorkspace
    module Config
      def credential_path
        ENV["GOOGLE_WORKSPACE_CREDENTIAL_PATH"]
      end

      def token_path(path)
        @_token_path ||= ENV["GOOGLE_WORKSPACE_TOKEN_PATH"] || path
      end

      def actor
        @_actor ||= actor!
      end

      def actor!
        if ENV["GOOGLE_WORKSPACE_ACTOR"].nil?
          print("input actor primary mail address:")
          return $stdin.gets.chomp!("\n")
        end

        ENV["GOOGLE_WORKSPACE_ACTOR"]
      end

      def domains(domains_file_path: nil)
        path = domains_file_path || ENV["DOMAINS_FILE_PATH"]
        if path.nil?
          print "input your domains file path:"
          path = $stdin.gets.chomp!("\n")
        end
        YAML.load_file(path)["domains"]
      end
    end
  end
end

