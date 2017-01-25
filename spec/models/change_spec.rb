require 'rails_helper'

RSpec.describe Change, type: :model do

  let(:project_user) { FactoryGirl.create(:project_user) }
  let(:project_team) { FactoryGirl.create(:project_team) }

  describe ".parts" do
    before(:example) do
      FactoryGirl.create(:document, name: "999", version: 1, position: 1, project: project_user)
      FactoryGirl.create(:document, name: "888", version: 1, position: 2, project: project_user)
      FactoryGirl.create(:document, name: "777", version: 1, position: 3, project: project_user)
      FactoryGirl.create(:document, name: "555", version: 2, position: 2, project: project_user)

      FactoryGirl.create(:change, project: project_user)
      FactoryGirl.create(:change, project: project_user)
    end

    context "Get list by the version number" do
      it "Should be [9,5,7] when get lastest list" do
        expect(project_user.lastest_change.parts(project_user, :documents).map(&:name)).to eq ["999", "555", "777"]
      end

      it "Should be [9,8,7] when get list of version 1" do
        change = project_user.version_changes.find_by(position: 1)
        expect(change.parts(project_user, :documents).map(&:name)).to eq ["999", "888", "777"]
      end
    end

    context "Have a discarded document" do
      before(:example) do
        FactoryGirl.create(:document, name: "666", version: 1, position: 4, discard_version: 2, project: project_user)
        FactoryGirl.create(:document, name: "444", version: 3, position: 3, project: project_user)
        FactoryGirl.create(:change, project: project_user)
      end

      it "Should be [9,5,4] when get lastest list" do
        expect(project_user.lastest_change.parts(project_user, :documents).map(&:name)).to eq ["999", "555", "444"]
      end

      it "Should be [9,5,7] when get list of version 2" do
        change = project_user.version_changes.find_by(position: 2)
        expect(change.parts(project_user, :documents).map(&:name)).to eq ["999", "555", "777"]
      end

      it "Should be [9,8,7,6] when get list of version 1" do
        change = project_user.version_changes.find_by(position: 1)
        expect(change.parts(project_user, :documents).map(&:name)).to eq ["999", "888", "777", "666"]
      end
    end
  end

end
