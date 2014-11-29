json.array!(@tenders) do |tender|
  json.extract! tender, :id, :model, :price, :description, :state, :created_at, :updated_at, :cancel_reason
  json.user tender, :user_name if current_user

  json.bargain_id tender.bargain.id if tender.bargain

  if @dealer && tender.bargain.bids
    bid = tender.bargain.bids.first
    if bid && bid.dealer == @dealer
      json.bid_id bid.id
      json.bider "you"
      json.dealer_id @dealer.id
      json.user tender, :user_name
      json.user tender.user, :phone
    elsif tender.deal && tender.deal.dealer.shop == @dealer.shop
      json.bider "your_shop"
      json.dealer_id tender.deal.dealer.id
    else
      json.bider "others"
    end
  end

  # json.first_round_bids (tender.bids_count.to_i - (tender.bargain ? tender.bargain.bids_count.to_i : 0))
  # json.second_round_bids (tender.bargain ? tender.bargain.bids_count : 0 )
  json.url tender_url(tender, format: :json)
  json.pic_url tender.car_trim.model.pics.first.pic_url
  json.bargain_id tender.bargain.id if tender.bargain
end
