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

ActiveRecord::Schema[8.1].define(version: 2026_09_23_192452) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "locations", force: :cascade do |t|
    t.string "address_line_1", null: false
    t.string "address_line_2"
    t.string "city", null: false
    t.string "country_code", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email", null: false
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.string "phone", null: false
    t.string "postal_code", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "organization_id"], name: "index_locations_on_id_and_organization_id", unique: true
    t.index ["organization_id", "name"], name: "index_locations_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_locations_on_organization_id"
  end

  create_table "membership_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "location_id"
    t.bigint "membership_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "permission_id", null: false
    t.string "scope_type", default: "location", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_membership_permissions_on_location_id"
    t.index ["membership_id", "permission_id", "location_id"], name: "unique_location_permission_grants", unique: true, where: "((scope_type)::text = 'location'::text)"
    t.index ["membership_id", "permission_id"], name: "unique_organization_permission_grants", unique: true, where: "((scope_type)::text = 'organization'::text)"
    t.index ["membership_id"], name: "index_membership_permissions_on_membership_id"
    t.index ["permission_id"], name: "index_membership_permissions_on_permission_id"
    t.check_constraint "scope_type::text = 'organization'::text AND location_id IS NULL OR scope_type::text = 'location'::text AND location_id IS NOT NULL", name: "membership_permissions_valid_scope_type"
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "organization_id", null: false
    t.string "status", default: "active", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["id", "organization_id"], name: "index_memberships_on_id_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["user_id", "organization_id"], name: "index_memberships_on_user_id_and_organization_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "address_line_1", null: false
    t.string "address_line_2"
    t.string "city", null: false
    t.string "country_code", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email", null: false
    t.string "name", null: false
    t.string "phone", null: false
    t.string "postal_code", null: false
    t.string "regon"
    t.string "slug", null: false
    t.string "tax_id", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["name"], name: "index_organizations_on_name", unique: true
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
    t.index ["tax_id"], name: "index_organizations_on_tax_id", unique: true
  end

  create_table "permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_permissions_on_key", unique: true
    t.index ["name"], name: "index_permissions_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "locations", "organizations"
  add_foreign_key "membership_permissions", "locations", column: ["location_id", "organization_id"], primary_key: ["id", "organization_id"], name: "fk_grants_locations_organization", on_delete: :cascade
  add_foreign_key "membership_permissions", "memberships", column: ["membership_id", "organization_id"], primary_key: ["id", "organization_id"], name: "fk_grants_membership_organization", on_delete: :cascade
  add_foreign_key "membership_permissions", "permissions", on_delete: :cascade
  add_foreign_key "memberships", "organizations", on_delete: :restrict
  add_foreign_key "memberships", "users", on_delete: :restrict
end
