json.extract! @tender, :id, :trim_id, :colors_ids, :price, :pickup_time, :license_location, :got_licence, :loan_option, :description, :created_at, :updated_at, :state, :cancel_reason


[@brand, @maker, @model, @trim].each do |item|
  namespace = item.class.name.demodulize.underscore
  json.set! namespace do
    json.set! :id, item.id
    json.set! :name, item.name
  end
  # json.extract!(item, :id, :name)
  # json.extract!(item, :id, :name)
end

# json.extract!(@maker, :id, :name)

json.pic_url @tender.car_trim.model.pics.first.pic_url

json.set! :states do
  json.set! :determined, I18n.t("tender.state.determined")
  json.set! :qualified, I18n.t("tender.state.qualified")
  json.set! :timeout, I18n.t("tender.state.timeout")
  # json.set! :submitted, I18n.t("tender.state.submitted")
  json.set! :deal_made, I18n.t("tender.state.deal_made")
  json.set! :final_deal_closed, I18n.t("tender.state.final_deal_closed")
  json.set! :canceled, I18n.t("tender.state.canceled")
end

json.colors @colors, :name, :code

if @bid && @tender.state == 'deal_made' && current_user
  json.verfiy_code verify_deal_url(@deal, code: @deal.verify_code) if @deal
  json.dealer @dealer, :phone if @dealer
  json.shop @shop, :name, :address if @shop

  json.bid @bid, :insurance, :purchase_tax, :license_fee, :misc_fee, :description, :price
  json.bider @bid.dealer, :id, :phone
  json.user @tender, :user_name
end