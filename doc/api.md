ALL none get requests need set content-type=application/json header
All parameters can refer to html form input fields

Home:
GET /home.json

Register:
POST /users/register.json   post body   { "user" : { "phone" : "13800000000" } }
POST /dealers/register.json post body   { "dealer" : { "phone" : "13800000000" } }


Reset Password:
POST /users/reset_pwd       post body   { "user" : { "phone" : "13800000000" } }
POST /dealers/reset_pwd     post body   { "dealer" : { "phone" : "13800000000" } }

Login:
POST /users/sign_in.json    post body   { "user" : { "phone" : "13800000000", "password" : "password" } }


Register Device Push:
POST /devices.json          post body:
{ "type" : "baidu_push", "device" : { "baidu_user_id" : "baiduid", "baidu_channel_id" : "baiduchannel" } }

Cars:
GET /cars/list.json
GET /cars/trims.json?model_name=A3


Shops:
GET /shops.json?trim_id=1 # shops api for specified trim


Create Tender:
--------------
POST /tedners.json
post body:
{
  "tender"=>{
    "price"=>"123",
    "trim_id"=>"1",
    "colors_ids"=>"1,6,9,11",
    "shops"=>{"1"=>"1", "4"=>"1"},
    "pickup_time"=>"尽快",
    "license_location"=>"上海",
    "got_licence"=>"0",
    "loan_option"=>"2",
    "user_name"=>"2",
  }
}


User Tender:
GET /tenders.json?page=1
GET /tenders/1.json


Dealer Tender:
GET /tenders/dealer_index.json?page=1
GET /tenders/{bargain_id}/show_bargain.json

抢单:
----
POST /bids.json  post body { "bid" : { "bargain_id" : "123" } }
更新具体报价:
PATCH /bids/1.json post body
{"bid":{"insurance":"123", "vehicle_tax":"123", "purchase_tax":"123", "license_fee":"123", "misc_fee":"123", "description":"123"}}



GET /deals.json


POST /tenders/1/submit.json

POST /bargains/5/submit.json

DELETE /tenders/3/cancel_1_round.json

GET /tenders/2/bargain.json

POST /tenders/2/submit_bargain.json

POST /bids/23/accept.json

POST /bids/24/accept_final.json

GET /deals.json

GET /deals/4/verify.json?code=234asdf

