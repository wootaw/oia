require "rails_helper"

RSpec.describe CollaboratorMailer, type: :mailer do

  let(:collaborator)  { create(:collaborator_invitation) }
  let(:invite_email)  { CollaboratorMailer.invite_email(collaborator) }

  it "renders the headers" do
    expect(invite_email.subject).to eq("#{collaborator.user.username} has invited you to collaborate on #{collaborator.project.name}")
    expect(invite_email.to).to eq([collaborator.member.email])
    expect(invite_email.from).to eq(["noreply@apiwoods.com"])
  end

  it "renders the body" do
    expect(invite_email.body.encoded).to match("/invitations/#{collaborator.member.key}")
  end
end
