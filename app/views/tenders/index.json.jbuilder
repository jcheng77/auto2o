json.array!(@tenders) do |tender|
  json.extract! tender, :id, :model, :price, :description
  json.url tender_url(tender, format: :json)
end
