if response
  json.(response, :id, :name, :location, :summary, :data_type, :array, :ancestor)
  json.md_description markdown(response.raw_description(change))
end