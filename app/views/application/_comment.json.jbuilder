if comment
  json.(comment, :id, :position)
  json.md_body markdown(comment.body)
  json.user do
    json.partial! 'user', user: @comment.user, avatar_size: :sm
  end
  json.created distance_of_time_in_words_to_now(comment.created_at)
  json.updated distance_of_time_in_words_to_now(comment.updated_at)
end