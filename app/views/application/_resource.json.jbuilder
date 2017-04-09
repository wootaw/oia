if resource
  json.(resource, :id, :slug, :summary, :method, :path, :position)
  json.md_description markdown(resource.raw_description(change))
  json.comments_total resource.comments.count
  json.parameters resource.the_parameters(change) do |parameter|
    json.partial! partial: 'parameter', locals: { parameter: parameter, change: change }
  end
  json.responses resource.the_responses(change) do |response|
    json.partial! partial: 'response', locals: { response: response, change: change }
  end
end