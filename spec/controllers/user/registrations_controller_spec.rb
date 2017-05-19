require 'rails_helper'

RSpec.describe User::RegistrationsController, type: :controller do

  let(:rest)    { JSON.parse(response.body).symbolize_keys }

  before(:example) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe ':create' do
    let(:collaborator) { create(:collaborator_invitation) }
    let(:params) do
      {
        username: 'abc',
        password: '123123'
      }
    end

    it 'should not redirect to project if invitation key is not exists' do
      params[:email] = collaborator.member.email
      
      post :create, params: { user: params, invitation_key: "xyz" }
      expect(rest[:redirect]).to eq "/abc"
    end

    it 'should redirect to project if user be invite' do
      params[:email] = collaborator.member.email
      
      post :create, params: { user: params, invitation_key: collaborator.member.key }
      expect(rest[:redirect]).to eq "/#{collaborator.project.owner_name}/#{collaborator.project.name}"
    end

    it 'should joined to project if user be invite' do
      params[:email] = collaborator.member.email
      
      post :create, params: { user: params, invitation_key: collaborator.member.key }
      expect(collaborator.project.collaborators.count).to eq 2
      expect(collaborator.project.signed_collaborators.take.joined?).to be_truthy
      expect(collaborator.project.unsign_collaborators.take.confirmed?).to be_truthy
    end
  end
end
