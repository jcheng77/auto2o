# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141226102112) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "bargains", force: true do |t|
    t.integer  "user_id"
    t.integer  "tender_id"
    t.integer  "dealer_id"
    t.decimal  "price",      precision: 12, scale: 2
    t.string   "postscript"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bids_count"
  end

  create_table "bids", force: true do |t|
    t.integer  "tender_id"
    t.integer  "bargain_id"
    t.integer  "dealer_id"
    t.decimal  "price",        precision: 12, scale: 2
    t.string   "description"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "insurance",    precision: 12, scale: 2
    t.decimal  "vehicle_tax",  precision: 12, scale: 2
    t.decimal  "purchase_tax", precision: 12, scale: 2
    t.decimal  "license_fee",  precision: 12, scale: 2
    t.decimal  "misc_fee",     precision: 12, scale: 2
  end

  create_table "brands_shops", force: true do |t|
    t.integer "brand_id"
    t.integer "shop_id"
  end

  create_table "car_brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_url"
  end

  create_table "car_colors", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_makers", force: true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_models", force: true do |t|
    t.string   "name"
    t.integer  "year"
    t.integer  "maker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_models_shops", force: true do |t|
    t.integer "model_id"
    t.integer "shop_id"
  end

  create_table "car_pics", force: true do |t|
    t.string   "pic_url"
    t.integer  "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_prices", force: true do |t|
    t.date     "offering_date"
    t.decimal  "price",         precision: 12, scale: 2
    t.integer  "trim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_trims", force: true do |t|
    t.string   "name"
    t.integer  "model_id"
    t.decimal  "guide_price", precision: 12, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count"
  end

  create_table "cars", force: true do |t|
    t.string   "name"
    t.string   "model"
    t.decimal  "price",      precision: 12, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "shop_id"
    t.integer  "dealer_id"
    t.text     "content"
    t.integer  "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "deal_id"
  end

  create_table "dealers", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "sms_confirmation_token",   limit: 5
    t.datetime "confirmation_sms_sent_at"
    t.datetime "sms_confirmed_at"
    t.string   "role"
    t.integer  "shop_id"
    t.datetime "last_reset_at"
    t.integer  "points",                             default: 0
    t.date     "last_checkin_at"
  end

  add_index "dealers", ["email"], name: "index_dealers_on_email", unique: true, using: :btree
  add_index "dealers", ["reset_password_token"], name: "index_dealers_on_reset_password_token", unique: true, using: :btree
  add_index "dealers", ["sms_confirmation_token"], name: "index_dealers_on_sms_confirmation_token", unique: true, using: :btree

  create_table "deals", force: true do |t|
    t.integer  "user_id"
    t.integer  "tender_id"
    t.integer  "bid_id"
    t.integer  "bargain_id"
    t.integer  "dealer_id"
    t.decimal  "final_price", precision: 12, scale: 2
    t.string   "postscript"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "verify_code"
  end

  add_index "deals", ["verify_code"], name: "index_deals_on_verify_code", unique: true, using: :btree

  create_table "deposits", force: true do |t|
    t.integer  "user_id"
    t.integer  "tender_id"
    t.decimal  "sum",             precision: 10, scale: 0
    t.string   "state"
    t.string   "trade_no"
    t.string   "broker_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "aplipay_account"
  end

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.integer  "dealer_id"
    t.integer  "admin_user_id"
    t.string   "push_id"
    t.string   "type"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "baidu_user_id"
    t.string   "baidu_channel_id"
  end

  create_table "shops", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  create_table "shops_tenders", force: true do |t|
    t.integer "shop_id"
    t.integer "tender_id"
  end

  create_table "tenders", force: true do |t|
    t.integer  "user_id"
    t.integer  "trim_id"
    t.string   "model"
    t.decimal  "price",                      precision: 12, scale: 2
    t.string   "description"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bids_count"
    t.string   "colors_ids"
    t.string   "pickup_time"
    t.string   "license_location"
    t.integer  "got_licence",      limit: 1
    t.integer  "loan_option"
    t.string   "user_name"
    t.string   "cancel_reason"
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "sms_confirmation_token",   limit: 5
    t.datetime "confirmation_sms_sent_at"
    t.datetime "sms_confirmed_at"
    t.datetime "last_reset_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["sms_confirmation_token"], name: "index_users_on_sms_confirmation_token", unique: true, using: :btree

end
