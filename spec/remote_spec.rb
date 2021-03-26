require_relative "../lib/josef/remote.rb"

class JosefRemoteTest
  include Josef::Remote
end
RSpec.describe Josef do
  let(:client) { Google::Apis::AdminDirectoryV1::DirectoryService.new }
  let(:josef) { JosefRemoteTest.new }
  let(:domains) { { domains:
    %w(
      ml.example.com
      ml.sample.com
    )
    }
  }
  let(:actor) { "actor@sample.com" }
  describe "remote" do
    before do
      allow(josef).to receive(:client) { client }
      allow(josef.client).to receive(:list_groups).and_return(response("groups.list"))
      allow(josef.client).to receive(:list_members).and_return(response("members.list"))
      allow(josef).to receive(:domains).and_return(domains)
      allow(josef).to receive(:actor).and_return(actor)
    end
    it "can fetch remote groups" do
      remote_groups = [
        {
          group_mail_address: "test@ml.example.com",
          members: %w(
            member@sample.com
            sample@ml.example.com
          )
        },
        {
          group_mail_address:"sample@ml.sample.com",
          members: %w(
            member@sample.com
            sample@ml.example.com
          )
        }
      ]
      expect(josef.remote).to eq remote_groups
    end
  end
end
