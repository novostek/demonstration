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

ActiveRecord::Schema.define(version: 2020_02_13_035313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calculation_formulas", force: :cascade do |t|
    t.string "name"
    t.string "formula"
    t.string "description"
    t.boolean "tax"
    t.string "namespace"
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

  create_table "document_files", force: :cascade do |t|
    t.string "title"
    t.text "file"
    t.string "origin"
    t.integer "origin_id"
    t.boolean "esign"
    t.json "esign_data"
    t.string "photo"
    t.date "photo_date"
    t.text "photo_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "color"
    t.string "namespace"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.index ["calculation_formula_id"], name: "index_products_on_calculation_formula_id"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "permissions"
  end

  create_table "settings", force: :cascade do |t|
    t.string "namespace"
    t.json "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workers", force: :cascade do |t|
    t.string "name"
    t.text "photo"
    t.string "document_id"
    t.string "categories"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "products", "calculation_formulas"
  add_foreign_key "products", "product_categories"
  add_foreign_key "products", "suppliers"
end
