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

ActiveRecord::Schema[7.1].define(version: 2024_05_18_132919) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.bigint "user_id", null: false
    t.index ["category_id"], name: "index_collections_on_category_id"
    t.index ["user_id", "name"], name: "index_collections_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "item_field_descriptions", force: :cascade do |t|
    t.string "name"
    t.string "data_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "collection_id", null: false
    t.index ["collection_id", "name"], name: "index_item_field_descriptions_on_collection_id_and_name", unique: true
    t.index ["collection_id"], name: "index_item_field_descriptions_on_collection_id"
  end

  create_table "item_field_values", force: :cascade do |t|
    t.integer "int_value"
    t.string "string_value"
    t.text "text_value"
    t.boolean "boolean_boolean"
    t.datetime "date_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "item_id", null: false
    t.bigint "item_field_description_id", null: false
    t.index ["item_field_description_id"], name: "index_item_field_values_on_item_field_description_id"
    t.index ["item_id"], name: "index_item_field_values_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "collection_id", null: false
    t.index ["collection_id", "name"], name: "index_items_on_collection_id_and_name", unique: true
    t.index ["collection_id"], name: "index_items_on_collection_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "role", default: "user"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "collections", "categories"
  add_foreign_key "collections", "users"
  add_foreign_key "item_field_descriptions", "collections"
  add_foreign_key "item_field_values", "item_field_descriptions"
  add_foreign_key "item_field_values", "items"
  add_foreign_key "items", "collections"
end
