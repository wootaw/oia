if user
  json.(user, :id, :username)
  json.avatar_url user.avatar_url(avatar_size)
end