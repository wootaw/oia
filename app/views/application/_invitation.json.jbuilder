if invitation
  json.(invitation, :id, :email)
  json.avatar_url nil
end