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

ActiveRecord::Schema.define(version: 20161009090357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "ngo_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "street"
    t.string   "zip"
    t.string   "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_contacts_on_deleted_at", using: :btree
    t.index ["ngo_id"], name: "index_contacts_on_ngo_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.text     "description"
    t.string   "address"
    t.float    "lat"
    t.float    "lng"
    t.string   "state",       default: "pending", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "ngo_id"
    t.string   "title"
    t.index ["ngo_id"], name: "index_events_on_ngo_id", using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ngos", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "locale",                 default: 0
    t.datetime "deleted_at"
    t.datetime "admin_confirmed_at"
    t.index ["admin_confirmed_at"], name: "index_ngos_on_admin_confirmed_at", where: "(deleted_at IS NULL)", using: :btree
    t.index ["confirmation_token"], name: "index_ngos_on_confirmation_token", where: "(deleted_at IS NULL)", using: :btree
    t.index ["deleted_at"], name: "index_ngos_on_deleted_at", using: :btree
    t.index ["email"], name: "index_ngos_on_email", where: "(deleted_at IS NULL)", using: :btree
    t.index ["reset_password_token"], name: "index_ngos_on_reset_password_token", where: "(deleted_at IS NULL)", using: :btree
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "shift_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shift_id"], name: "index_participations_on_shift_id", using: :btree
    t.index ["user_id"], name: "index_participations_on_user_id", using: :btree
  end

  create_table "qualifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "ability_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ability_id"], name: "index_qualifications_on_ability_id", using: :btree
    t.index ["user_id"], name: "index_qualifications_on_user_id", using: :btree
  end

  create_table "shifts", force: :cascade do |t|
    t.integer  "event_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "volunteers_needed"
    t.integer  "volunteers_count",  default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["event_id"], name: "index_shifts_on_event_id", using: :btree
  end

  create_table "spoken_languages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "language_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["language_id"], name: "index_spoken_languages_on_language_id", using: :btree
    t.index ["user_id"], name: "index_spoken_languages_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin",                  default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "api_token"
    t.datetime "api_token_valid_until"
    t.integer  "locale",                 default: 0
    t.string   "phone"
    t.datetime "deleted_at"
    t.index ["api_token"], name: "index_users_on_api_token", where: "(deleted_at IS NULL)", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", where: "(deleted_at IS NULL)", using: :btree
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["email"], name: "index_users_on_email", where: "(deleted_at IS NULL)", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", where: "(deleted_at IS NULL)", using: :btree
  end

  add_foreign_key "events", "ngos"
end
