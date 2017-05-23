if collaborator
  json.(collaborator, :id)
  json.members do
    case collaborator.member_type
    when "User"
      json.partial! 'user', user: collaborator.member, avatar_size: :sm
    when "Invitation"
      json.partial! 'invitation', invitation: collaborator.member
    end
  end
end