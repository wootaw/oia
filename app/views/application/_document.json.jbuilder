if document
  json.(document, :id, :name, :summary, :position)
  json.md_description markdown(document.raw_description(change))
  json.resources document.the_resources(change) do |resource|
    json.partial! partial: 'resource', locals: { resource: resource, change: change }
  end
end