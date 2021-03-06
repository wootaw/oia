require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:project) { create :project }
  let(:user)    { create :user }
  let(:rest)    { JSON.parse(response.body).symbolize_keys }

  describe ':create' do
    it 'should not allow anonymous create' do
      post :create
      expect(response).not_to be_success
    end

    it 'should not create new project if owner is not current user' do
      sign_in user
      params = build(:project_user).attributes.symbolize_keys
      post :create, params: { project: params }
      expect(response).not_to be_success
    end

    it 'should not create new project if name is not present' do
      sign_in user
      params = build(:project, owner: user).attributes.symbolize_keys
      params[:name] = nil
      post :create, params: { project: params }
      expect(response).to be_success

      expect(rest[:code]).to eq 1000
    end

    it 'should create new project if all is well' do
      sign_in user
      params = build(:project, owner: user).attributes.symbolize_keys
      post :create, params: { project: params }
      expect(response).to be_success

      expect(Project.find(rest[:projects]["id"]).collaborators.count).to eq 1
    end
  end

end
