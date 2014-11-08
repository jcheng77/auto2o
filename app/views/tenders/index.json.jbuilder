json.array!(@tenders) do |tender|
  json.extract! tender, :id, :model, :price, :description, :state, :created_at, :updated_at

  json.bargain_id tender.bargain.id if tender.bargain

  if tender.bargain.bids
    bid = tender.bargain.bids.first
    if bid && bid.dealer == @dealer
      json.bid_id bid.id
      json.bider "you"
      json.dealer_id @dealer.id
    end
  end

  if tender.deal && @dealer
    if tender.deal.dealer == @dealer
      json.bider "you"
      json.dealer_id tender.deal.dealer.id
    elsif tender.deal.dealer.shop == @dealer.shop
      json.bider "your_shop"
      json.dealer_id tender.deal.dealer.id
    end
  end

  # json.first_round_bids (tender.bids_count.to_i - (tender.bargain ? tender.bargain.bids_count.to_i : 0))
  # json.second_round_bids (tender.bargain ? tender.bargain.bids_count : 0 )
  json.url tender_url(tender, format: :json)
  json.pic_url tender.car_trim.model.pics.first.pic_url
  json.bargain_id tender.bargain.id if tender.bargain
end
