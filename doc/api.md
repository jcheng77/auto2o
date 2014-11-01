Home:
GET /home.json

Register:
POST /users/register.json  user[phone] = 123123123  or { "user" : { "phone" : "123123123" } }
POST /dealers/register.json dealer[phone] = 123123123 or { "dealer" : { "phone" : "123123123" } }

Cars:
GET /cars/list.json
GET /cars/trims.json?model_name=A3


Shops:
GET /shops.json?trim_id=1 # shops api for specified trim


User Tender:
GET /tenders.json
GET /tenders/1.json


Dealer Tender:
GET /tenders/dealer_index.json
GET /tenders/{bargain_id}/show_bargain.json

抢单:
----
POST /bargains/{bargain_id}/submit






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

