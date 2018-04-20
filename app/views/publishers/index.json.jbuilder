json.array!(@publishers) do |publisher|
  json.extract! publisher, :id, :name, :information
  json.url publisher_url(publisher, format: :json)
end
