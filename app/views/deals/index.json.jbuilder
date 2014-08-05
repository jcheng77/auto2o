json.array!(@deals) do |deal|
  json.extract! deal, :id, :user_id, :tender_id, :bid_id, :bargain_id, :dealer_id, :final_price, :postscript
  json.url deal_url(deal, format: :json)
end
