# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_26_154619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_policies", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.text "description"
    t.boolean "dock_groups"
    t.boolean "docks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "enabled", default: true
    t.boolean "everything"
    t.index ["company_id"], name: "index_access_policies_on_company_id"
  end

  create_table "auth/users", force: :cascade do |t|
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
    t.bigint "access_policy_id"
    t.index ["access_policy_id"], name: "index_auth/users_on_access_policy_id"
    t.index ["company_id"], name: "index_auth/users_on_company_id"
    t.index ["username"], name: "index_auth/users_on_username", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "dock_groups", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.boolean "enabled", default: true
    t.index ["company_id"], name: "index_dock_groups_on_company_id"
    t.index ["description", "company_id"], name: "index_dock_groups_on_description_and_company_id", unique: true
  end

# Could not dump table "dock_request_audit_histories" because of following StandardError
#   Unknown type 'dock_request_audit_history_event' for column 'event'

# Could not dump table "dock_requests" because of following StandardError
#   Unknown type 'dock_request_status' for column 'status'

  create_table "docks", force: :cascade do |t|
    t.text "number"
    t.boolean "enabled", default: true
    t.bigint "dock_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_docks_on_company_id"
    t.index ["dock_group_id"], name: "index_docks_on_dock_group_id"
  end

  add_foreign_key "access_policies", "companies"
  add_foreign_key "auth/users", "access_policies"
  add_foreign_key "auth/users", "companies"
  add_foreign_key "dock_groups", "companies"
  add_foreign_key "dock_request_audit_histories", "\"auth/users\"", column: "user_id"
  add_foreign_key "dock_request_audit_histories", "companies"
  add_foreign_key "dock_request_audit_histories", "dock_requests"
  add_foreign_key "dock_request_audit_histories", "docks"
  add_foreign_key "dock_requests", "companies"
  add_foreign_key "dock_requests", "dock_groups"
  add_foreign_key "dock_requests", "docks"
  add_foreign_key "docks", "companies"
  add_foreign_key "docks", "dock_groups"
end
