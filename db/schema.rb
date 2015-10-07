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

ActiveRecord::Schema.define(version: 20150907145542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advertisers", force: true do |t|
    t.string   "name"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_games", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "thumb_60"
    t.string   "thumb_120"
    t.string   "thumb_180"
    t.string   "external_link"
    t.string   "orientation"
    t.datetime "game_added"
    t.decimal  "aspect_ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_category_rels", force: true do |t|
    t.integer  "feed_game_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.integer  "device_type"
  end

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "jackpots", force: true do |t|
    t.string   "name"
    t.integer  "max_entries"
    t.datetime "draw_date"
    t.string   "prize"
    t.boolean  "open"
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.integer  "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "user_entries", force: true do |t|
    t.integer  "user_id"
    t.integer  "jackpot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_game_sessions", force: true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "credits_earned"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
    t.integer  "challenge_id"
    t.integer  "credits_applied", default: 0
  end

  create_table "user_surveys", force: true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.boolean  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
    t.integer  "credits"
    t.date     "dob"
    t.string   "zipcode"
    t.integer  "gender"
    t.string   "provider"
    t.string   "uid"
    t.string   "oath_name"
    t.string   "oath_image"
    t.string   "oath_token"
    t.datetime "oath_expires_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "lifetime_credits"
    t.integer  "pending_credits"
    t.string   "referral"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
