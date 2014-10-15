GET http://127.0.0.1:3001/home.json

GET http://127.0.0.1:3001/cars/list.json
GET http://127.0.0.1:3001/cars/trims.json?model_name=A3

GET http://127.0.0.1:3001/deals.json

GET http://127.0.0.1:3001/tenders.json

GET http://127.0.0.1:3001/tenders/1.json

GET /tenders/new.json?trim=1&color[1]=1&color[6]=1   # shops api for specified trim and colors

POST http://127.0.0.1:3001/tenders/1/submit.json

POST http://127.0.0.1:3001/bargains/5/submit.json

DELETE http://127.0.0.1:3001/tenders/3/cancel_1_round.json

GET http://127.0.0.1:3001/tenders/2/bargain.json

POST http://127.0.0.1:3001/tenders/2/submit_bargain.json

POST http://127.0.0.1:3001/bids/23/accept.json

POST http://127.0.0.1:3001/bids/24/accept_final.json

GET http://127.0.0.1:3001/deals.json

GET http://127.0.0.1:3001/deals/4/verify.json?code=234asdf

POST http://127.0.0.1:3001/users/register.json  user[phone] = 123123123  or { "user" : { "phone" : "123123123" } }

POST http://127.0.0.1:3001/dealers/register.json dealer[phone] = 123123123 or { "dealer" : { "phone" : "123123123" } }