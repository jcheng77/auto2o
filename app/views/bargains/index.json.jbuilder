json.array!(@bargains) do |bargain|
  json.extract! bargain, :id, :user_id, :tender_id, :bid_id, :dealer_id, :price, :postscript
  json.url bargain_url(bargain, format: :json)
end
