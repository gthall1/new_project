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

ActiveRecord::Schema.define(version: 20160320151933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advertisers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "logo",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_users", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "arrivals", force: :cascade do |t|
    t.string   "landing_url", limit: 255
    t.string   "referer",     limit: 255
    t.string   "user_agent",  limit: 255
    t.string   "ip",          limit: 255
    t.string   "mobile",      limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "referred_by"
  end

  create_table "cash_outs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "credits"
    t.integer  "cash"
    t.string   "venmo",        limit: 255
    t.string   "paypal",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cashout_type"
    t.integer  "arrival_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "challenged_user_id"
    t.integer  "game_id"
    t.integer  "winner_id"
    t.integer  "challenged_score"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_score"
  end

  create_table "feed_games", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "description",   limit: 255
    t.string   "thumb_60",      limit: 255
    t.string   "thumb_120",     limit: 255
    t.string   "thumb_180",     limit: 255
    t.string   "external_link", limit: 255
    t.string   "orientation",   limit: 255
    t.datetime "game_added"
    t.decimal  "aspect_ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_category_rels", force: :cascade do |t|
    t.integer  "feed_game_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image",         limit: 255
    t.integer  "device_type"
    t.string   "slug",          limit: 255
    t.integer  "sort_order"
    t.string   "desktop_image"
    t.integer  "credit_cost"
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "jackpots", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "max_entries"
    t.datetime "draw_date"
    t.string   "prize",       limit: 255
    t.boolean  "open"
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "purchase_type_id"
    t.integer  "purchase_record_id"
    t.integer  "credits_spent"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "surveys", force: :cascade do |t|
    t.integer  "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
    t.string   "slug"
  end

  create_table "user_entries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "jackpot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_game_sessions", force: :cascade do |t|
    t.string   "token",             limit: 255
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "credits_earned"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
    t.integer  "challenge_id"
    t.integer  "credits_applied",               default: 0
    t.integer  "arrival_id"
    t.integer  "version"
    t.datetime "last_score_update"
  end

  add_index "user_game_sessions", ["arrival_id"], name: "index_user_game_sessions_on_arrival_id", using: :btree
  add_index "user_game_sessions", ["created_at"], name: "index_user_game_sessions_on_created_at", using: :btree
  add_index "user_game_sessions", ["game_id"], name: "index_user_game_sessions_on_game_id", using: :btree
  add_index "user_game_sessions", ["updated_at"], name: "index_user_game_sessions_on_updated_at", using: :btree
  add_index "user_game_sessions", ["user_id"], name: "index_user_game_sessions_on_user_id", using: :btree

  create_table "user_surveys", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.boolean  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "arrival_id"
    t.integer  "credits"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "email",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",  limit: 255
    t.string   "remember_token",   limit: 255
    t.boolean  "admin"
    t.integer  "credits"
    t.date     "dob"
    t.string   "zipcode",          limit: 255
    t.integer  "gender"
    t.string   "provider",         limit: 255
    t.string   "uid",              limit: 255
    t.string   "oath_name",        limit: 255
    t.string   "oath_image",       limit: 255
    t.string   "oath_token",       limit: 255
    t.datetime "oath_expires_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "lifetime_credits"
    t.integer  "pending_credits"
    t.string   "referral",         limit: 255
    t.string   "reset_digest",     limit: 255
    t.datetime "reset_sent_at"
    t.string   "firstname",        limit: 255
    t.string   "lastname",         limit: 255
    t.integer  "arrival_id"
    t.boolean  "email_verified",               default: false
    t.string   "verify_token"
    t.integer  "user_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
