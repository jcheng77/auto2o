json.extract! @tender, :id, :model, :trim_id, :price, :pickup_time, :license_location, :got_licence, :loan_option, :description, :created_at, :updated_at, :state
json.pic_url @tender.car_trim.model.pics.first.pic_url

json.set! :states do
  json.set! :determined, I18n.t("tender.state.determined")
  json.set! :qualified, I18n.t("tender.state.qualified")
  json.set! :timeout, I18n.t("tender.state.timeout")
  json.set! :submitted, I18n.t("tender.state.submitted")
  json.set! :deal_made, I18n.t("tender.state.deal_made")
  json.set! :final_deal_closed, I18n.t("tender.state.final_deal_closed")
end

json.verfiy_code verify_deal_url(@deal, code: @deal.verify_code) if @deal

json.dealer @dealer, :phone if @dealer
json.shop @shop, :name, :address if @shop