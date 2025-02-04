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

ActiveRecord::Schema.define(version: 2020_03_11_215920) do

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
    t.boolean "dock_queue"
    t.boolean "order_order_groups"
    t.boolean "shipper_profiles"
    t.index ["company_id"], name: "index_access_policies_on_company_id"
  end

# Could not dump table "companies" because of following StandardError
#   Unknown type 'company_type' for column 'company_type'

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

  create_table "order_order_groups", force: :cascade do |t|
    t.text "description", null: false
    t.boolean "enabled", default: true
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_order_order_groups_on_company_id"
  end

  create_table "shipper_profiles", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "shipper_id", null: false
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id", "shipper_id"], name: "index_shipper_profiles_on_company_id_and_shipper_id", unique: true
    t.index ["company_id"], name: "index_shipper_profiles_on_company_id"
    t.index ["enabled"], name: "index_shipper_profiles_on_enabled"
    t.index ["shipper_id"], name: "index_shipper_profiles_on_shipper_id"
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
    t.bigint "access_policy_id"
    t.index ["access_policy_id"], name: "index_users_on_access_policy_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "access_policies", "companies"
  add_foreign_key "dock_groups", "companies"
  add_foreign_key "dock_request_audit_histories", "companies"
  add_foreign_key "dock_request_audit_histories", "dock_requests"
  add_foreign_key "dock_request_audit_histories", "docks"
  add_foreign_key "dock_request_audit_histories", "users"
  add_foreign_key "dock_requests", "companies"
  add_foreign_key "dock_requests", "dock_groups"
  add_foreign_key "dock_requests", "docks"
  add_foreign_key "docks", "companies"
  add_foreign_key "docks", "dock_groups"
  add_foreign_key "order_order_groups", "companies"
  add_foreign_key "shipper_profiles", "companies"
  add_foreign_key "shipper_profiles", "companies", column: "shipper_id"
  add_foreign_key "users", "access_policies"
  add_foreign_key "users", "companies"
end
