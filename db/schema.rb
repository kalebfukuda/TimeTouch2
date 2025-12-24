# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_12_24_094524) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gembas", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_gembas_on_company_id"
  end

  create_table "periods", force: :cascade do |t|
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name", null: false
    t.float "salary", default: 0.0
    t.boolean "can_drive", default: false
    t.bigint "role_id", null: false
    t.bigint "company_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.float "previous_salary"
    t.date "date_start_salary"
    t.index ["company_id"], name: "index_profiles_on_company_id"
    t.index ["role_id"], name: "index_profiles_on_role_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "registers", force: :cascade do |t|
    t.datetime "date", null: false
    t.float "extra_hour"
    t.integer "extra_cost"
    t.bigint "gemba_id", null: false
    t.bigint "period_id", null: false
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "salary"
    t.string "note"
    t.index ["gemba_id"], name: "index_registers_on_gemba_id"
    t.index ["period_id"], name: "index_registers_on_period_id"
    t.index ["profile_id"], name: "index_registers_on_profile_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "gemba_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "period_id"
    t.index ["gemba_id"], name: "index_schedules_on_gemba_id"
    t.index ["period_id"], name: "index_schedules_on_period_id"
    t.index ["profile_id"], name: "index_schedules_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "gembas", "companies"
  add_foreign_key "profiles", "companies"
  add_foreign_key "profiles", "roles"
  add_foreign_key "profiles", "users"
  add_foreign_key "registers", "gembas"
  add_foreign_key "registers", "periods"
  add_foreign_key "registers", "profiles"
  add_foreign_key "schedules", "gembas"
  add_foreign_key "schedules", "periods"
  add_foreign_key "schedules", "profiles"
end
