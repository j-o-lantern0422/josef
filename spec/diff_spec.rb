require_relative "../lib/josef/diff.rb"

class JosefRemoteTest
  include Josef::Diff
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

  let(:local_groups) {[
    {
      "group_mail_address": "group1@ml.example.com",
      "members": ["member1@example.com", "member2@example.com"]
    }
  ]}

  let(:remote_groups) {[ ]}
  describe "diff" do
    before do
      allow(josef).to receive(:client) { client }
      allow(josef.client).to receive(:list_groups).and_return(response("groups.list"))
      allow(josef.client).to receive(:list_members).and_return(response("members.list"))
      allow(josef).to receive(:domains).and_return(domains)
      allow(josef).to receive(:actor).and_return(actor)
    end
    it "new local group will be create" do
      new_group = {
        "group_mail_address": "newgroup@ml.example.com",
        "members": []
      }
      allow(josef).to receive(:remote).and_return(remote_groups)

      expect(josef.be_create?(new_group)).to eq true
    end
  end
end
