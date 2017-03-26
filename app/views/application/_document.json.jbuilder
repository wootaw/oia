if document
  json.(document, :id, :name, :summary, :position)
  json.md_description raw(Sanitize.fragment(document.raw_description(change), Apiwoods::Sanitize::DEFAULT))
  json.resources document.the_resources(change) do |resource|
    json.partial! partial: 'resource', locals: { resource: resource, change: change }
  end
  # json.created distance_of_time_in_words_to_now(project.created_at)
  # json.updated distance_of_time_in_words_to_now(project.updated_at)
  # json.version project.version_number
end