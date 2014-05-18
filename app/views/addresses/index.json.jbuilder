json.array!(@addresses) do |address|
  json.extract! address, :id, :name, :type, :fullname, :parent_id
  json.url address_url(address, format: :json)
end
