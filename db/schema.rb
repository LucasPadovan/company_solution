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

ActiveRecord::Schema.define(version: 20180224173756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budget_lines", force: :cascade do |t|
    t.bigint "budget_id"
    t.bigint "product_id"
    t.float "unit_price"
    t.string "currency"
    t.float "tax_rate"
    t.string "unit"
    t.integer "position"
    t.float "price_change"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_budget_lines_on_budget_id"
    t.index ["product_id"], name: "index_budget_lines_on_product_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.bigint "firm_id"
    t.bigint "user_id"
    t.string "number"
    t.date "date"
    t.date "from"
    t.date "to"
    t.string "destinatary"
    t.string "contact"
    t.string "title"
    t.string "header_image"
    t.string "body_image"
    t.string "pdf_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["firm_id"], name: "index_budgets_on_firm_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "certificate_details", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "certificate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certificate_id"], name: "index_certificate_details_on_certificate_id"
    t.index ["product_id"], name: "index_certificate_details_on_product_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "website"
    t.string "email"
    t.integer "wait_time"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "area"
    t.text "details"
    t.bigint "firm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["firm_id"], name: "index_contacts_on_firm_id"
  end

  create_table "firms", force: :cascade do |t|
    t.string "name"
    t.string "cuit"
    t.string "afip_condition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.time "opens_at"
    t.time "closes_at"
  end

  create_table "order_lines", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "product_id"
    t.float "amount"
    t.float "unit_price"
    t.float "subtotal"
    t.float "tax_rate"
    t.float "tax"
    t.float "remaining_amount"
    t.integer "position"
    t.string "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.index ["order_id"], name: "index_order_lines_on_order_id"
    t.index ["product_id"], name: "index_order_lines_on_product_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.bigint "order_id"
    t.decimal "status"
    t.string "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_statuses_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "number"
    t.string "tracking_code"
    t.string "type"
    t.string "currency"
    t.string "contact_name"
    t.string "detail"
    t.float "total"
    t.float "subtotal"
    t.float "taxes"
    t.float "deliver_fee"
    t.float "packaging_fee"
    t.datetime "expected_deliver_from"
    t.datetime "expected_deliver_to"
    t.datetime "date"
    t.bigint "firm_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["firm_id"], name: "index_orders_on_firm_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.date "from_date"
    t.date "to_date"
    t.bigint "certificate_id"
    t.bigint "firm_id"
    t.text "contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certificate_id"], name: "index_permissions_on_certificate_id"
    t.index ["firm_id"], name: "index_permissions_on_firm_id"
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "trade_id"
    t.decimal "price"
    t.decimal "min_quantity"
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.string "currency"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "tax_rate"
    t.index ["trade_id"], name: "index_prices_on_trade_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "area"
    t.bigint "user_id"
    t.string "type"
    t.string "unit"
    t.decimal "initial_stock"
    t.decimal "current_stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "internal_name"
    t.string "internal_code"
    t.string "external_code"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_recipes_on_product_id"
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "product_id"
    t.datetime "from"
    t.datetime "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sold_by"
    t.integer "sold_to"
    t.index ["product_id"], name: "index_trades_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "lastname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "budget_lines", "budgets"
  add_foreign_key "budget_lines", "products"
  add_foreign_key "budgets", "firms"
  add_foreign_key "budgets", "users"
  add_foreign_key "certificate_details", "certificates"
  add_foreign_key "certificate_details", "products"
  add_foreign_key "contacts", "firms"
  add_foreign_key "order_lines", "orders"
  add_foreign_key "order_lines", "products"
  add_foreign_key "order_statuses", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "permissions", "certificates"
  add_foreign_key "permissions", "firms"
  add_foreign_key "prices", "trades"
  add_foreign_key "products", "users"
  add_foreign_key "recipes", "products"
  add_foreign_key "trades", "products"
end
