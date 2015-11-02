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

ActiveRecord::Schema.define(version: 20151102183953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "needs", force: :cascade do |t|
    t.string   "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "volunteers_needed",   default: 1, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "city"
    t.integer  "category",            default: 0, null: false
    t.integer  "user_id"
    t.decimal  "lat"
    t.decimal  "lng"
    t.integer  "volunteerings_count", default: 0, null: false
    t.text     "description"
  end

  add_index "needs", ["user_id"], name: "index_needs_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.boolean  "admin",                  default: false,   null: false
    t.boolean  "ngo_admin",              default: false,   null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.text     "tokens"
    t.boolean  "admin_confirmed",        default: true,    null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  create_table "volunteerings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "need_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "volunteerings", ["need_id"], name: "index_volunteerings_on_need_id", using: :btree
  add_index "volunteerings", ["user_id"], name: "index_volunteerings_on_user_id", using: :btree

end
