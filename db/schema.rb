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

ActiveRecord::Schema.define(version: 20141227063521) do

  create_table "products", force: true do |t|
    t.string   "name"
    t.integer  "sku_id"
    t.integer  "shop_id"
    t.string   "availability"
    t.decimal  "price",        precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["shop_id"], name: "index_products_on_shop_id"
  add_index "products", ["sku_id"], name: "index_products_on_sku_id"

  create_table "shops", force: true do |t|
    t.integer  "skroutz_id"
    t.string   "name"
    t.string   "link"
    t.string   "image_url"
    t.boolean  "free_shipping"
    t.decimal  "free_shipping_from", precision: 8, scale: 2
    t.decimal  "shipping_min_price", precision: 8, scale: 2
    t.integer  "reviews_count"
    t.decimal  "review_score",       precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skus", force: true do |t|
    t.string   "name"
    t.decimal  "price_max",  precision: 8, scale: 2
    t.decimal  "price_min",  precision: 8, scale: 2
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skus_users", id: false, force: true do |t|
    t.integer "sku_id"
    t.integer "user_id"
  end

  add_index "skus_users", ["sku_id", "user_id"], name: "index_skus_users_on_sku_id_and_user_id"
  add_index "skus_users", ["user_id"], name: "index_skus_users_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "full_name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
