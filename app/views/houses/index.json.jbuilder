json.array!(@houses) do |house|
  json.extract! house, :id, :name, :address_id
  json.url house_url(house, format: :json)
end