if project
  json.(project, :id, :name, :summary)
  json.created distance_of_time_in_words_to_now(project.created_at)
  json.updated distance_of_time_in_words_to_now(project.updated_at)
  json.version project.version_number
  json.owned project.owned?(current_user)
  json.documents_count project.documents.count
  json.resources_count project.resources.count
end