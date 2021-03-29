require "bundler/setup"
require "josef"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture(api_method)
  JSON.parse(File.read("spec/fixtures/#{api_method}.json")).deep_symbolize_keys
end

def local_groups_path
  "spec/local_files/local_groups.yml"
end

def members_response
  member1 = ::Google::Apis::AdminDirectoryV1::Member.new(**{
    "kind": "admin#directory#member",
    "etag": "\"kaqc57-i7NoUBo7psvjUJg\"",
    "id": "02bn639743829387ohm5",
    "email": "member@sample.com",
    "role": "MEMBER",
    "type": "USER",
    "status": "ACTIVE"
  })

  member2 = ::Google::Apis::AdminDirectoryV1::Member.new(**{
    "kind": "admin#directory#member",
    "etag": "\"TQEIrASO8Jwul60cVbfvfw\"",
    "id": "02bn6wsx1pmohm5",
    "email": "sample@ml.example.com",
    "role": "MEMBER",
    "type": "GROUP",
    "status": "ACTIVE"
  })

  members = ::Google::Apis::AdminDirectoryV1::Members.new(**fixture("members.list"))
  members.members.push(member1, member2)

  members
end

def groups_response
  group1 = ::Google::Apis::AdminDirectoryV1::Group.new(**{
    "kind": "admin#directory#group",
    "id": "YEzMnTFD3lHpzXEf1qMR3A",
    "etag": "\"D_RQuq1sD2FjO9T0lOwwNg\"",
    "email": "test@ml.example.com",
    "name": "example_ML_ml.example.com",
    "directMembersCount": "4",
    "description": "",
    "adminCreated": true
  })

  group2 = ::Google::Apis::AdminDirectoryV1::Group.new(**{
    "kind": "admin#directory#group",
    "id": "uPGsWWM-DHRM05DUn1rP8g",
    "etag": "\"nEb5hHa9V5Rfp-X_NWZBLA\"",
    "email": "sample@ml.sample.com",
    "name": "sample",
    "directMembersCount": "3",
    "description": "",
    "adminCreated": true,
    "aliases": [
      "sample@ml.exapmle.com"
    ]
  })

  groups = ::Google::Apis::AdminDirectoryV1::Groups.new(**fixture("groups.list"))
  groups.groups.push(group1, group2)

  groups
end

def response(api_method = nil)
  return groups_response if api_method == "groups.list"
  return members_response if api_method == "members.list"
end
