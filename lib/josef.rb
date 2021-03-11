require "josef/version"
require "thor"
require "google/apis/admin_directory_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

module Josef
  class Error < StandardError; end
  # Your code goes here...
end
