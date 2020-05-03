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

ActiveRecord::Schema.define(version: 2020_04_19_152545) do

  create_table "finance_transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "payee_type"
    t.bigint "payee_id"
    t.string "receiver_type"
    t.bigint "receiver_id"
    t.string "finance_type"
    t.bigint "finance_id"
    t.decimal "amount", precision: 10, scale: 2
    t.date "transaction_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["finance_type", "finance_id"], name: "index_finance_transactions_on_finance_type_and_finance_id", length: { finance_type: 191 }
    t.index ["payee_type", "payee_id"], name: "index_finance_transactions_on_payee_type_and_payee_id", length: { payee_type: 191 }
    t.index ["receiver_type", "receiver_id"], name: "index_finance_transactions_on_receiver_type_and_receiver_id", length: { receiver_type: 191 }
  end

  create_table "instant_transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.date "transaction_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "purchase_stores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "owner_name"
    t.string "place"
    t.string "phone"
    t.string "email"
    t.string "pincode"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "purchases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "purchase_store_id"
    t.date "purchase_date"
    t.decimal "total_weight", precision: 10, scale: 2
    t.decimal "open_rate", precision: 10, scale: 2
    t.decimal "confirmed_rate", precision: 10, scale: 2
    t.decimal "total_amount", precision: 10, scale: 2
    t.integer "user_id"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sales", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "store_id"
    t.date "selling_date"
    t.integer "total_box_count"
    t.decimal "total_weight", precision: 10, scale: 2
    t.decimal "empty_box_weight", precision: 10, scale: 2
    t.decimal "item_weight", precision: 10, scale: 2
    t.decimal "rate", precision: 10, scale: 2
    t.decimal "expected_amount", precision: 10, scale: 2
    t.decimal "paid_amount", precision: 10, scale: 2
    t.decimal "balance_amount", precision: 10, scale: 2
    t.integer "user_id"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "owner_name"
    t.string "place"
    t.string "phone"
    t.string "email"
    t.string "pincode"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "password_digest"
    t.string "salt"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "weekend_amount_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.date "sold_date"
    t.boolean "amount_calculated", default: false
    t.decimal "total_amount", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
