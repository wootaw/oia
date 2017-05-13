class CollaboratorMailer < ApplicationMailer

  def invite_email(collaborator)
    @collaborator = collaborator
    mail(
      to: @collaborator.member.email, 
      subject: "#{@collaborator.user.username} has invited you to collaborate on #{@collaborator.project.name}"
    )
  end
end
