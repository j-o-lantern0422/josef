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

  let(:excluded_groups) {%w(
    exclueded_group@example.com
  )}

  let(:remote_groups) {[ ]}
  describe "diff" do
    before do
      allow(josef).to receive(:client) { client }
      allow(josef.client).to receive(:list_groups).and_return(response("groups.list"))
      allow(josef.client).to receive(:list_members).and_return(response("members.list"))
      allow(josef).to receive(:domains).and_return(domains)
      allow(josef).to receive(:actor).and_return(actor)
      allow(josef).to receive(:exculued_groups).and_return(excluded_groups)
    end
    it "new local group will be create" do
      new_group = {
        "group_mail_address": "newgroup@ml.example.com",
        "members": []
      }
      allow(josef).to receive(:remote).and_return(remote_groups)

      expect(josef.be_create?(new_group)).to eq true
    end

    it "was not changed, not be create" do
      remote_groups = local_groups
      allow(josef).to receive(:remote).and_return(remote_groups)

      expect(josef.be_create?(local_groups.sample)).to eq false
    end

    it "deleted local group will be derete" do
      be_delete_group = {
        "group_mail_address": "deleted_group@ml.example.com",
        "members": []
      }
      remote_groups.push(local_groups).push(be_delete_group)
      allow(josef).to receive(:remote).and_return(remote_groups)

      expect(josef.be_delete?(remote_groups)).to eq true
    end

    it "was not deleted, not be delete" do
      remote_groups = local_groups
      allow(josef).to receive(:remote).and_return(remote_groups)

      expect(josef.be_create?(local_groups.sample)).to eq false
    end

    it "was changed, will be change members" do
      remote_groups = local_groups.deep_dup
      remote_groups.sample[:members].push("new_member@example.com")

      allow(josef).to receive(:remote).and_return(remote_groups)
      expect(josef.changed?(local_groups.sample)).to eq true
    end

    it "was not changed, will not be change members" do
      remote_groups = local_groups
      allow(josef).to receive(:remote).and_return(remote_groups)

      expect(josef.changed?(local_groups.sample)).to eq false
    end

    it "was not exclueded group, will targeting group" do
      expect(josef.should_be_tareget?(local_groups.sample)).to eq true
    end

    it "was excluded group, will not targeting group" do
      expected_local_group = {
        "group_mail_address": excluded_groups.first,
        "members": []
      }

      expect(josef.should_be_tareget?(expected_local_group)).to eq false
    end
  end
end
