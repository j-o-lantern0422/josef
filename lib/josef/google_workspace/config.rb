module Josef
  module GoogleWorkspace
    module Config
      def credential_path
        ENV["GOOGLE_WORKSPACE_CREDENTIAL_PATH"]
      end

      def token_path(path)
        @_token_path ||= ENV["GOOGLE_WORKSPACE_TOKEN_PATH"] || path
      end
    end
  end
end

