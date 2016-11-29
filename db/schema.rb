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

ActiveRecord::Schema.define(version: 20161129222256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artisanal_geocoders", force: :cascade do |t|
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facilities", force: :cascade do |t|
    t.string   "parking"
    t.string   "water_spot"
    t.string   "shop"
    t.string   "safety_watch"
    t.string   "shower"
    t.text     "comment"
    t.integer  "spot_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["spot_id"], name: "index_facilities_on_spot_id", using: :btree
  end

  create_table "favorite_spots", force: :cascade do |t|
    t.integer  "spot_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_favorite_spots_on_spot_id", using: :btree
    t.index ["user_id"], name: "index_favorite_spots_on_user_id", using: :btree
  end

  create_table "forecasts", force: :cascade do |t|
    t.datetime "date_time"
    t.integer  "wind_direction"
    t.float    "wind_strength"
    t.float    "wind_gusting"
    t.string   "weather"
    t.integer  "spot_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["spot_id"], name: "index_forecasts_on_spot_id", using: :btree
  end

  create_table "harbors", force: :cascade do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "query"
  end

  create_table "recommended_wind_directions", force: :cascade do |t|
    t.integer  "spot_id"
    t.integer  "sector_start"
    t.integer  "sector_end"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["spot_id"], name: "index_recommended_wind_directions_on_spot_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "spot_id"
    t.integer  "user_id"
    t.string   "content"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_reviews_on_spot_id", using: :btree
    t.index ["user_id"], name: "index_reviews_on_user_id", using: :btree
  end

  create_table "spots", force: :cascade do |t|
    t.integer  "harbor_id"
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "accepted",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["harbor_id"], name: "index_spots_on_harbor_id", using: :btree
    t.index ["user_id"], name: "index_spots_on_user_id", using: :btree
  end

  create_table "tides", force: :cascade do |t|
    t.integer  "harbor_id"
    t.boolean  "high_tide"
    t.integer  "coefficient"
    t.datetime "date_time"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["harbor_id"], name: "index_tides_on_harbor_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "ambassador",             default: false
    t.integer  "weight"
    t.string   "first_name"
    t.string   "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "weather_feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "spot_id"
    t.integer  "direction"
    t.float    "strength"
    t.float    "wing_size"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_weather_feedbacks_on_spot_id", using: :btree
    t.index ["user_id"], name: "index_weather_feedbacks_on_user_id", using: :btree
  end

  add_foreign_key "facilities", "spots"
  add_foreign_key "favorite_spots", "spots"
  add_foreign_key "favorite_spots", "users"
  add_foreign_key "forecasts", "spots"
  add_foreign_key "recommended_wind_directions", "spots"
  add_foreign_key "reviews", "spots"
  add_foreign_key "reviews", "users"
  add_foreign_key "spots", "harbors"
  add_foreign_key "spots", "users"
  add_foreign_key "tides", "harbors"
  add_foreign_key "weather_feedbacks", "spots"
  add_foreign_key "weather_feedbacks", "users"
end
