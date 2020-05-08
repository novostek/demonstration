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

ActiveRecord::Schema.define(version: 2020_05_08_190008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "area_proposals", force: :cascade do |t|
    t.bigint "measurement_area_id", null: false
    t.bigint "measurement_proposal_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["measurement_area_id"], name: "index_area_proposals_on_measurement_area_id"
    t.index ["measurement_proposal_id"], name: "index_area_proposals_on_measurement_proposal_id"
  end

  create_table "calculation_formulas", force: :cascade do |t|
    t.string "name"
    t.string "formula"
    t.string "description"
    t.boolean "tax"
    t.string "namespace"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "tenant_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "category"
    t.string "title"
    t.json "value"
    t.string "origin"
    t.integer "origin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "data"
    t.boolean "main"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "document_id"
    t.date "since"
    t.string "code"
    t.date "birthdate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "bpm_instance"
  end

  create_table "document_custom_fields", force: :cascade do |t|
    t.string "name"
    t.bigint "document_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["document_id"], name: "index_document_custom_fields_on_document_id"
  end

  create_table "document_files", force: :cascade do |t|
    t.string "title"
    t.text "file"
    t.string "origin"
    t.integer "origin_id"
    t.boolean "esign"
    t.json "esign_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
  end

  create_table "document_sends", force: :cascade do |t|
    t.string "origin"
    t.integer "origin_id"
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "data"
    t.string "sub_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "doc_type"
    t.json "custom_fields"
  end

  create_table "estimates", force: :cascade do |t|
    t.string "code", null: false
    t.string "title"
    t.bigint "sales_person_id"
    t.string "status", null: false
    t.text "description", null: false
    t.string "location", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "category", null: false
    t.bigint "order_id"
    t.decimal "price"
    t.decimal "tax"
    t.bigint "tax_calculation_id"
    t.bigint "lead_id"
    t.string "bpmn_instance"
    t.boolean "current"
    t.decimal "total", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "link"
    t.string "taxpayer"
    t.index ["lead_id"], name: "index_estimates_on_lead_id"
    t.index ["order_id"], name: "index_estimates_on_order_id"
    t.index ["sales_person_id"], name: "index_estimates_on_sales_person_id"
    t.index ["tax_calculation_id"], name: "index_estimates_on_tax_calculation_id"
    t.index ["taxpayer"], name: "index_estimates_on_taxpayer"
  end

  create_table "labor_costs", force: :cascade do |t|
    t.bigint "worker_id", null: false
    t.bigint "schedule_id", null: false
    t.date "date"
    t.decimal "value"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["schedule_id"], name: "index_labor_costs_on_schedule_id"
    t.index ["worker_id"], name: "index_labor_costs_on_worker_id"
  end

  create_table "leads", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "via"
    t.text "description"
    t.string "status"
    t.datetime "date"
    t.string "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.index ["customer_id"], name: "index_leads_on_customer_id"
  end

  create_table "measurement_areas", force: :cascade do |t|
    t.bigint "estimate_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "cloned_from"
    t.index ["estimate_id"], name: "index_measurement_areas_on_estimate_id"
  end

  create_table "measurement_proposals", force: :cascade do |t|
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "measurements", force: :cascade do |t|
    t.bigint "measurement_area_id", null: false
    t.decimal "width"
    t.decimal "height"
    t.decimal "length"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "square_feet", precision: 10, scale: 2
    t.index ["measurement_area_id"], name: "index_measurements_on_measurement_area_id"
  end

  create_table "menus", force: :cascade do |t|
    t.boolean "active"
    t.string "icon"
    t.string "name"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.integer "position"
    t.index ["ancestry"], name: "index_menus_on_ancestry"
  end

  create_table "notes", force: :cascade do |t|
    t.string "title", null: false
    t.text "text", null: false
    t.boolean "private"
    t.string "origin", null: false
    t.integer "origin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "code"
    t.string "status"
    t.string "bpmn_instance"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "photos"
    t.decimal "total_cost"
  end

  create_table "plutus_accounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.boolean "contra", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "transaction_category_id", null: false
    t.index ["name", "type"], name: "index_plutus_accounts_on_name_and_type"
    t.index ["transaction_category_id"], name: "index_plutus_accounts_on_transaction_category_id"
  end

  create_table "plutus_amounts", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "account_id"
    t.integer "entry_id"
    t.decimal "amount", precision: 20, scale: 10
    t.index ["account_id", "entry_id"], name: "index_plutus_amounts_on_account_id_and_entry_id"
    t.index ["entry_id", "account_id"], name: "index_plutus_amounts_on_entry_id_and_account_id"
    t.index ["type"], name: "index_plutus_amounts_on_type"
  end

  create_table "plutus_entries", id: :serial, force: :cascade do |t|
    t.string "description"
    t.date "date"
    t.integer "commercial_document_id"
    t.string "commercial_document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commercial_document_id", "commercial_document_type"], name: "index_entries_on_commercial_doc"
    t.index ["date"], name: "index_plutus_entries_on_date"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "color"
    t.string "namespace"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "product_estimates", force: :cascade do |t|
    t.bigint "product_id"
    t.string "custom_title"
    t.text "notes"
    t.decimal "unitary_value"
    t.decimal "quantity"
    t.decimal "discount"
    t.decimal "value"
    t.boolean "tax"
    t.bigint "measurement_proposal_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["measurement_proposal_id"], name: "index_product_estimates_on_measurement_proposal_id"
    t.index ["product_id"], name: "index_product_estimates_on_product_id"
  end

  create_table "product_purchases", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "purchase_id", null: false
    t.decimal "unity_value"
    t.decimal "quantity"
    t.decimal "value"
    t.string "status"
    t.string "custom_title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "tax", default: false
    t.index ["product_id"], name: "index_product_purchases_on_product_id"
    t.index ["purchase_id"], name: "index_product_purchases_on_purchase_id"
  end

  create_table "product_suggestions", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "suggestion_id"
    t.index ["product_id"], name: "index_product_suggestions_on_product_id"
    t.index ["suggestion_id"], name: "index_product_suggestions_on_suggestion_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.text "details"
    t.bigint "product_category_id", null: false
    t.decimal "customer_price"
    t.decimal "cost_price"
    t.decimal "area_covered"
    t.boolean "tax"
    t.string "bpm_purchase"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "supplier_id", null: false
    t.bigint "calculation_formula_id", null: false
    t.text "photo"
    t.index ["calculation_formula_id"], name: "index_products_on_calculation_formula_id"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "profile_menus", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "profile_id", null: false
    t.index ["menu_id"], name: "index_profile_menus_on_menu_id"
    t.index ["profile_id"], name: "index_profile_menus_on_profile_id"
  end

  create_table "profile_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_profile_users_on_profile_id"
    t.index ["user_id"], name: "index_profile_users_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "permissions"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "supplier_id"
    t.decimal "value"
    t.string "status"
    t.string "bpm_instance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_purchases_on_order_id"
    t.index ["supplier_id"], name: "index_purchases_on_supplier_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "worker_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string "category"
    t.string "color"
    t.string "origin"
    t.integer "origin_id"
    t.string "bpmn_instance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "hour_cost"
    t.index ["worker_id"], name: "index_schedules_on_worker_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "namespace"
    t.json "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "signatures", force: :cascade do |t|
    t.string "origin"
    t.integer "origin_id"
    t.text "file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "testes", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transaction_accounts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "color"
    t.string "namespace"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transaction_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "color"
    t.string "namespace"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "category"
    t.bigint "transaction_category_id"
    t.bigint "transaction_account_id"
    t.bigint "order_id"
    t.string "origin"
    t.date "due"
    t.datetime "effective"
    t.decimal "value"
    t.string "bpm_instance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "square_data"
    t.bigint "purchase_id"
    t.integer "origin_id"
    t.string "payment_method"
    t.string "email"
    t.string "status"
    t.index ["order_id"], name: "index_transactions_on_order_id"
    t.index ["purchase_id"], name: "index_transactions_on_purchase_id"
    t.index ["transaction_account_id"], name: "index_transactions_on_transaction_account_id"
    t.index ["transaction_category_id"], name: "index_transactions_on_transaction_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.boolean "active"
    t.bigint "worker_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["worker_id"], name: "index_users_on_worker_id"
  end

  create_table "workers", force: :cascade do |t|
    t.string "name"
    t.text "photo"
    t.string "document_id"
    t.string "categories"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "time_value"
  end

  add_foreign_key "area_proposals", "measurement_areas"
  add_foreign_key "area_proposals", "measurement_proposals"
  add_foreign_key "document_custom_fields", "documents"
  add_foreign_key "estimates", "calculation_formulas", column: "tax_calculation_id"
  add_foreign_key "estimates", "leads"
  add_foreign_key "estimates", "orders"
  add_foreign_key "estimates", "workers", column: "sales_person_id"
  add_foreign_key "labor_costs", "schedules"
  add_foreign_key "labor_costs", "workers"
  add_foreign_key "leads", "customers"
  add_foreign_key "measurement_areas", "estimates"
  add_foreign_key "measurements", "measurement_areas"
  add_foreign_key "plutus_accounts", "transaction_categories"
  add_foreign_key "product_estimates", "measurement_proposals"
  add_foreign_key "product_estimates", "products"
  add_foreign_key "product_purchases", "products"
  add_foreign_key "product_purchases", "purchases"
  add_foreign_key "product_suggestions", "products"
  add_foreign_key "product_suggestions", "products", column: "suggestion_id"
  add_foreign_key "products", "calculation_formulas"
  add_foreign_key "products", "product_categories"
  add_foreign_key "products", "suppliers"
  add_foreign_key "profile_menus", "menus"
  add_foreign_key "profile_menus", "profiles"
  add_foreign_key "profile_users", "profiles"
  add_foreign_key "profile_users", "users"
  add_foreign_key "purchases", "orders"
  add_foreign_key "purchases", "suppliers"
  add_foreign_key "schedules", "workers"
  add_foreign_key "transactions", "orders"
  add_foreign_key "transactions", "purchases"
  add_foreign_key "transactions", "transaction_accounts"
  add_foreign_key "transactions", "transaction_categories"
  add_foreign_key "users", "workers"
end
