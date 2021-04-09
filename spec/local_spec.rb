require_relative "../lib/josef/remote.rb"

class JosefLocalTest
  include Josef::Local
end
RSpec.describe Josef do
  let(:client) { Google::Apis::AdminDirectoryV1::DirectoryService.new }
  let(:josef) { JosefLocalTest.new }
  let(:domains) { { domains:
    %w(
      ml.example.com
      ml.sample.com
    )
    }
  }
  let(:actor) { "actor@sample.com" }
  describe "local" do
    before do
      allow(josef).to receive(:client) { client }
    end

    it "can load local groups" do
      local_groups = [
        {
          group_mail_address: "test-group@example.com",
          members: %w(
                        member@example.com
                      )
         },
         {
           group_mail_address: "test-ml@ml.example.com",
           members: %w(
                        member@example.com
                        member@sample.com
                      )
          }
      ]
      expect(josef.local(local_groups_path)).to eq local_groups
    end

    it "members is nil, it load as emtpy array" do
      local_groups = [
        {
          group_mail_address: "test-group@example.com",
          members: %w(
                        member@example.com
                      )
         },
         {
           group_mail_address: "test-ml@ml.example.com",
           members: []
          }
        ]
        expect(josef.local(emtpy_members_local_groups_path)).to eq local_groups

    end
  end
end
