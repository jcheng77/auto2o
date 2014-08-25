json.extract! @tender, :id, :model, :price, :description
json.url tender_url(@tender, format: :json)
json.reasons @reasons.each do |reason|
  json.resaon reason
end