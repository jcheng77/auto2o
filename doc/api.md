ALL none get requests need set content-type=application/json header
All parameters can refer to html form input fields

Home:
-----
GET /home.json

Register:
---------
POST /users/register.json   post body   { "user" : { "phone" : "13800000000" } }
POST /dealers/register.json post body   { "dealer" : { "phone" : "13800000000" } }


Reset Password:
---------------
POST /users/reset_pwd       post body   { "user" : { "phone" : "13800000000" } }
POST /dealers/reset_pwd     post body   { "dealer" : { "phone" : "13800000000" } }

Login:
------
POST /users/sign_in.json    post body   { "user" : { "phone" : "13800000000", "password" : "password" } }
POST /dealers/sign_in.json  post body   { "dealer" : { "phone" : "13800000000", "password" : "password" } }
need save server returned cookie

Logout:
-------
DELETE /users/sign_in.json
DELETE /dealers/sign_out.json


Register Device Push:
---------------------
POST /devices.json          post body:
{ "type" : "baidu_push", "device" : { "baidu_user_id" : "baiduid", "baidu_channel_id" : "baiduchannel" } }

Cars:
-----
GET /cars/list.json
GET /cars/trims.json?model_id=123  # include view count of car trim


Shops:
------
GET /shops.json?trim_id=1 # shops api for specified trim


Create Tender:
--------------
POST /tedners.json
post body:
{
  "tender" : {
    "price" : "123",
    "trim_id" : "1",
    "colors_ids" : "1,6,9,11",
    "shops" : {"10" : "1", "14" : "1", "15" : "1"},
    "pickup_time" : "尽快",
    "license_location" : "上海",
    "got_licence" : "0",
    "loan_option" : "2",
    "user_name" : "2",
    "description" : "optional parameter"
  }
}


Cancel Tender:
---------------
PATCH /tedners/1/cancel.json
post body:
{
  "tender" : {
    "cancel_reason" : "4s店优惠不给力",
  }
}

options:
4s店优惠不给力
4s店距离太远了
信息提交错误
选择其他车型了
推迟购买计划了

User Tender:
------------
GET /tenders.json?page=1
GET /tenders/1.json


Dealer Tender:
--------------
GET /tenders/dealer_index.json?page=1
GET /tenders/{bargain_id}/show_bargain.json

抢单:
----
POST /bids.json  post body { "bid" : { "bargain_id" : "123" } }
更新具体报价:
PATCH /bids/1.json post body
{"bid":{"insurance":"123", "vehicle_tax":"123", "purchase_tax":"123", "license_fee":"123", "misc_fee":"123", "description":"123"}}


扫码:
----
GET /deals/4/verify.json?code=234asdf

