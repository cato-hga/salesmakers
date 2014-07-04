# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140704164034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "area_types", force: true do |t|
    t.string   "name",       null: false
    t.integer  "project_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "areas", force: true do |t|
    t.string   "name",         null: false
    t.integer  "area_type_id", null: false
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id",   null: false
  end

  add_index "areas", ["ancestry"], name: "index_areas_on_ancestry", using: :btree

  create_table "clients", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.boolean  "corporate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_deployments", force: true do |t|
    t.integer  "device_id",       null: false
    t.integer  "person_id",       null: false
    t.date     "started",         null: false
    t.date     "ended"
    t.string   "tracking_number"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_manufacturers", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_models", force: true do |t|
    t.string   "name",                   null: false
    t.integer  "device_manufacturer_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_states", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_states_devices", id: false, force: true do |t|
    t.integer "device_id",       null: false
    t.integer "device_state_id", null: false
  end

  add_index "device_states_devices", ["device_id"], name: "index_device_states_devices_on_device_id", using: :btree
  add_index "device_states_devices", ["device_state_id"], name: "index_device_states_devices_on_device_state_id", using: :btree

  create_table "devices", force: true do |t|
    t.string   "identifier",      null: false
    t.string   "serial",          null: false
    t.integer  "device_model_id", null: false
    t.integer  "line_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_states", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_states_lines", id: false, force: true do |t|
    t.integer "line_id",       null: false
    t.integer "line_state_id", null: false
  end

  add_index "line_states_lines", ["line_id"], name: "index_line_states_lines_on_line_id", using: :btree
  add_index "line_states_lines", ["line_state_id"], name: "index_line_states_lines_on_line_state_id", using: :btree

  create_table "lines", force: true do |t|
    t.string   "identifier",                     null: false
    t.date     "contract_end_date",              null: false
    t.integer  "technology_service_provider_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_entries", force: true do |t|
    t.integer  "person_id",          null: false
    t.string   "action",             null: false
    t.text     "comment"
    t.integer  "trackable_id",       null: false
    t.string   "trackable_type",     null: false
    t.integer  "referenceable_id"
    t.string   "referenceable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "log_entries", ["person_id"], name: "index_log_entries_on_person_id", using: :btree
  add_index "log_entries", ["referenceable_id", "referenceable_type"], name: "index_log_entries_on_referenceable_id_and_referenceable_type", using: :btree
  add_index "log_entries", ["trackable_id", "trackable_type"], name: "index_log_entries_on_trackable_id_and_trackable_type", using: :btree

  create_table "people", force: true do |t|
    t.string   "first_name",                     null: false
    t.string   "last_name",                      null: false
    t.string   "display_name"
    t.string   "email",                          null: false
    t.string   "personal_email"
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",          default: true, null: false
    t.string   "connect_user_id"
    t.integer  "supervisor_id"
    t.string   "office_phone"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.integer  "eid"
  end

  create_table "person_areas", force: true do |t|
    t.integer  "person_id",                  null: false
    t.integer  "area_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "manages",    default: false, null: false
  end

  create_table "positions", force: true do |t|
    t.string   "name"
    t.boolean  "leadership"
    t.boolean  "all_field_visibility"
    t.boolean  "all_corporate_visibility"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name",       null: false
    t.integer  "client_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technology_service_providers", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
