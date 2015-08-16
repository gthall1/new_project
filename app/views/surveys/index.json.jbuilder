json.array!(@surveys) do |survey|
  json.extract! survey, 
  json.url survey_url(survey, format: :json)
end