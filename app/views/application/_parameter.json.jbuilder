if parameter
  json.(parameter, :id, :name, :location, :summary, :data_type, :array, :required, :default)
  json.md_description markdown(parameter.raw_description(change))
end