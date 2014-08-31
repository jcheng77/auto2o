json.array!(@tenders) do |tender|
  json.extract! tender, :id, :model, :price, :description
  json.first_round_bids (tender.bids_count.to_i - (tender.bargain ? tender.bargain.bids_count.to_i : 0))
  json.second_round_bids (tender.bargain ? tender.bargain.bids_count : 0 )
  json.url tender_url(tender, format: :json)
end
