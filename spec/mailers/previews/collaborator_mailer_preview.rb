# require 'rails_helper'

class CollaboratorMailerPreview < ActionMailer::Preview

  def invite_email
    # user = create(:user)
    # project = FactoryGirl.create(:project_user)
    project = Project.find_by(name: 'giant-api')
    invitation = Invitation.first
    collaborator = Collaborator.where(project: project, member: invitation).take
    # collaborator = FactoryGirl.create(:collaborator, invitation: invitation, project: project)
    CollaboratorMailer.invite_email(collaborator)
  end
end
