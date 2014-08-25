json.extract! @tender, :id, :model, :price, :description
json.url tender_url(@tender, format: :json)
json.bids @bids.each do |bid|
  json.extract! bid, :id, :tender_id, :dealer_id, :price, :description
  json.url bid_url(bid, format: :json)
end