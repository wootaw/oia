require 'rails_helper'

RSpec.describe Document, type: :model do
  let(:project_user) { FactoryGirl.create(:project_user) }
  let(:project_team) { FactoryGirl.create(:project_team) }

  # describe ".list_by_version" do
  #   context "" do
  #     it "" do
  #       FactoryGirl.create(:document, name: "999", version: 1, position: 1, project: project_user)
  #       FactoryGirl.create(:document, name: "888", version: 1, position: 2, project: project_user)
  #       FactoryGirl.create(:document, name: "777", version: 1, position: 3, project: project_user)
  #       FactoryGirl.create(:document, name: "555", version: 2, position: 2, project: project_user)

  #       project_user.list_by_version(:documents)
  #     end
  #   end
  # end
end
