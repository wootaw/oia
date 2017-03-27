if resource
  json.(resource, :id, :slug, :summary, :method, :path, :position)
  json.md_description markdown(resource.raw_description(change))
  # json.resources document.the_resources(change), partial: 'resource', as: :resource
  # json.created distance_of_time_in_words_to_now(project.created_at)
  # json.updated distance_of_time_in_words_to_now(project.updated_at)
  # json.version project.version_number
end