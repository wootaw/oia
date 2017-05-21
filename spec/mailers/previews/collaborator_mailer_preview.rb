# require 'rails_helper'

class CollaboratorMailerPreview < ActionMailer::Preview

  def invite_email
    project = Project.find_by(name: 'giant-api')
    invitation = Invitation.first
    collaborator = Collaborator.where(project: project, member: invitation).take
    CollaboratorMailer.invite_email(collaborator)
  end
end
