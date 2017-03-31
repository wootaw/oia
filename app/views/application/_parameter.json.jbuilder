if parameter
  json.(parameter, :id, :name, :location, :summary, :data_type, :array)
  json.md_description markdown(parameter.raw_description(change))
end