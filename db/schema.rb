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

ActiveRecord::Schema[7.0].define(version: 2023_04_13_152826) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "corporate_id", null: false
    t.string "branch_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "date_of_birth", null: false
    t.string "phone_number", null: false
    t.string "methodfi_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["corporate_id"], name: "index_employees_on_corporate_id", unique: true
    t.index ["methodfi_id"], name: "index_employees_on_methodfi_id", unique: true
  end

  create_table "employers", force: :cascade do |t|
    t.string "name", null: false
    t.string "dba"
    t.string "ein_number", null: false
    t.string "address_line_1", null: false
    t.string "address_line_2"
    t.string "address_city", null: false
    t.string "address_state", null: false
    t.string "address_zip", null: false
    t.string "methodfi_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ein_number"], name: "index_employers_on_ein_number", unique: true
    t.index ["methodfi_id"], name: "index_employers_on_methodfi_id", unique: true
  end

  create_table "payees", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "plaid_id", null: false
    t.string "account_number", null: false
    t.string "methodfi_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_number"], name: "index_payees_on_account_number", unique: true
    t.index ["employee_id"], name: "index_payees_on_employee_id"
    t.index ["methodfi_id"], name: "index_payees_on_methodfi_id", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "upload_id", null: false
    t.bigint "payee_id", null: false
    t.bigint "payor_id", null: false
    t.decimal "amount", precision: 9, scale: 2, null: false
    t.integer "status", default: 0, null: false
    t.string "methodfi_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["methodfi_id"], name: "index_payments_on_methodfi_id", unique: true
    t.index ["payee_id"], name: "index_payments_on_payee_id"
    t.index ["payor_id"], name: "index_payments_on_payor_id"
    t.index ["upload_id"], name: "index_payments_on_upload_id"
  end

  create_table "payors", force: :cascade do |t|
    t.string "corporate_id", null: false
    t.bigint "employer_id", null: false
    t.string "routing_number", null: false
    t.string "account_number", null: false
    t.string "methodfi_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_number"], name: "index_payors_on_account_number", unique: true
    t.index ["corporate_id"], name: "index_payors_on_corporate_id", unique: true
    t.index ["employer_id"], name: "index_payors_on_employer_id"
    t.index ["methodfi_id"], name: "index_payors_on_methodfi_id", unique: true
  end

  create_table "uploads", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "payees", "employees"
  add_foreign_key "payments", "payees"
  add_foreign_key "payments", "payors"
  add_foreign_key "payments", "uploads"
  add_foreign_key "payors", "employers"
end
