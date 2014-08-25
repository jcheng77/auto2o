json.array!(@dealers) do |dealer|
  json.extract! dealer, :id, :email, :created_at
  json.url dealer_url(dealer, format: :json)
end
