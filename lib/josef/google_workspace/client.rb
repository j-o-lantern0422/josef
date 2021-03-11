module Josef
  module GoogleWorkspace
    include Josef::GoogleWorkspace::Config
    module Client
      def initialize
        OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
        APPLICATION_NAME = "Josef".freeze
        SCOPE = Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_GROUP
      end

      def client
        @_client ||= client!
      end

      def client!
        service = Google::Apis::AdminDirectoryV1::DirectoryService.new
        service.client_options.application_name = APPLICATION_NAME
        service.authorization = authorize!

        service
      end

      def authorize!
        client_id = Google::Auth::ClientId.from_file(credential_path)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: token_path)
        authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
        user_id = "default"
        credentials = authorizer.get_credentials(user_id)
        if credentials.nil?
          url = authorizer.get_authorization_url base_url: OOB_URI
          puts "Open the following URL in the browser and enter the " \
               "resulting code after authorization:\n" + url
          code = gets
          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI
          )
        end
        credentials
      end
    end
  end
end

