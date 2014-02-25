json.array!(@groups) do |group|
  json.extract! group, :id, :name, :events_id, :tags_id, :description
  json.url group_url(group, format: :json)
end
