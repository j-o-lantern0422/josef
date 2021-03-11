require "josef/google_workspace/config"

OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
APP_NAME = "Josef".freeze
SCOPE = Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_GROUP

module Josef
  module GoogleWorkspace
    module Client
      include Josef::GoogleWorkspace::Config

      def client
        @_client ||= client!
      end

      def client!
        service = Google::Apis::AdminDirectoryV1::DirectoryService.new
        service.authorization = authorize!
        service.authorization.fetch_access_token!

        service
      end

      def authorize!
        Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: File.open(credential_path),
          scope: SCOPE)
      end
    end
  end
end

