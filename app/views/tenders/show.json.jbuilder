json.extract! @tender, :id, :model, :trim_id, :price, :pickup_time, :license_location, :got_licence, :loan_option, :description, :created_at, :updated_at, :state

json.set! :states do
   json.set! :determined, "信息已提交"
   json.set! :qualified, "定金已支付"
   json.set! :timeout, "无人应价"
   json.set! :submitted, "商家已报价"
   json.set! :final_deal_closed, "交易结束"
 end