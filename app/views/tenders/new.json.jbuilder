json.shops @shops.each do |shop|
  json.extract! shop, :id, :name, :address, :city_id
end