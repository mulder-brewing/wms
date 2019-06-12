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

ActiveRecord::Schema.define(version: 2019_06_09_200651) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.text "username"
    t.text "first_name"
    t.text "last_name"
    t.text "email"
    t.boolean "enabled", default: true
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "company_admin", default: false
    t.boolean "app_admin", default: false
    t.boolean "password_reset", default: true
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "users", "companies"
end
