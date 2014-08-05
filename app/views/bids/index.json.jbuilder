json.array!(@bids) do |bid|
  json.extract! bid, :id, :tender_id, :dealer_id, :price, :description
  json.url bid_url(bid, format: :json)
end
