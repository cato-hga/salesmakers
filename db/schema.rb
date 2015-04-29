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

ActiveRecord::Schema.define(version: 20150429163512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_upvotes", force: :cascade do |t|
    t.integer "answer_id", null: false
    t.datetime "created_at"
    t.integer "person_id", null: false
    t.datetime "updated_at"
  end

  add_index "answer_upvotes", ["answer_id"], name: "index_answer_upvotes_on_answer_id", using: :btree
  add_index "answer_upvotes", ["person_id"], name: "index_answer_upvotes_on_person_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at"
    t.integer "person_id", null: false
    t.integer "question_id", null: false
    t.datetime "updated_at"
  end

  add_index "answers", ["person_id"], name: "index_answers_on_person_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "area_candidate_sourcing_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "group_number"
    t.string "name", null: false
    t.integer "project_id", null: false
    t.datetime "updated_at", null: false
  end

  create_table "area_types", force: :cascade do |t|
    t.datetime "created_at"
    t.string "name", null: false
    t.integer "project_id", null: false
    t.datetime "updated_at"
  end

  add_index "area_types", ["project_id"], name: "index_area_types_on_project_id", using: :btree

  create_table "areas", force: :cascade do |t|
    t.string "ancestry"
    t.integer "area_candidate_sourcing_group_id"
    t.integer "area_type_id", null: false
    t.string "connect_salesregion_id"
    t.datetime "created_at"
    t.string "email"
    t.string "name", null: false
    t.string "personality_assessment_url"
    t.integer "project_id", null: false
    t.datetime "updated_at"
  end

  add_index "areas", ["ancestry"], name: "index_areas_on_ancestry", using: :btree
  add_index "areas", ["area_type_id"], name: "index_areas_on_area_type_id", using: :btree
  add_index "areas", ["project_id"], name: "index_areas_on_project_id", using: :btree

  create_table "blog_posts", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at"
    t.text "excerpt", null: false
    t.integer "person_id", null: false
    t.integer "score", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at"
  end

  add_index "blog_posts", ["person_id"], name: "index_blog_posts_on_person_id", using: :btree

  create_table "candidate_availabilities", force: :cascade do |t|
    t.integer "candidate_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.boolean "friday_first", default: false, null: false
    t.boolean "friday_second", default: false, null: false
    t.boolean "friday_third", default: false, null: false
    t.boolean "monday_first", default: false, null: false
    t.boolean "monday_second", default: false, null: false
    t.boolean "monday_third", default: false, null: false
    t.boolean "saturday_first", default: false, null: false
    t.boolean "saturday_second", default: false, null: false
    t.boolean "saturday_third", default: false, null: false
    t.boolean "sunday_first", default: false, null: false
    t.boolean "sunday_second", default: false, null: false
    t.boolean "sunday_third", default: false, null: false
    t.boolean "thursday_first", default: false, null: false
    t.boolean "thursday_second", default: false, null: false
    t.boolean "thursday_third", default: false, null: false
    t.boolean "tuesday_first", default: false, null: false
    t.boolean "tuesday_second", default: false, null: false
    t.boolean "tuesday_third", default: false, null: false
    t.datetime "updated_at", null: false
    t.boolean "wednesday_first", default: false, null: false
    t.boolean "wednesday_second", default: false, null: false
    t.boolean "wednesday_third", default: false, null: false
  end

  create_table "candidate_contacts", force: :cascade do |t|
    t.text "call_results"
    t.integer "candidate_id", null: false
    t.integer "contact_method", null: false
    t.datetime "created_at", null: false
    t.boolean "inbound", default: false, null: false
    t.text "notes", null: false
    t.integer "person_id", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidate_denial_reasons", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidate_drug_tests", force: :cascade do |t|
    t.integer "candidate_id"
    t.text "comments"
    t.datetime "created_at", null: false
    t.boolean "scheduled", default: false, null: false
    t.datetime "test_date"
    t.datetime "updated_at", null: false
  end

  create_table "candidate_reconciliations", force: :cascade do |t|
    t.integer "candidate_id", null: false
    t.datetime "created_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidate_sms_messages", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "text", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidate_sources", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidates", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "candidate_denial_reason_id"
    t.integer "candidate_source_id"
    t.datetime "created_at", null: false
    t.integer "created_by", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.float "latitude"
    t.integer "location_area_id"
    t.float "longitude"
    t.string "mobile_phone", null: false
    t.integer "person_id"
    t.boolean "personality_assessment_completed", default: false, null: false
    t.float "personality_assessment_score"
    t.integer "personality_assessment_status", default: 0, null: false
    t.integer "potential_area_id"
    t.string "shirt_gender"
    t.string "shirt_size"
    t.integer "sprint_radio_shack_training_session_id"
    t.string "state", limit: 2
    t.integer "status", default: 0, null: false
    t.string "suffix"
    t.integer "training_session_status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "zip", null: false
  end

  create_table "changelog_entries", force: :cascade do |t|
    t.boolean "all_field"
    t.boolean "all_hq"
    t.datetime "created_at", null: false
    t.integer "department_id"
    t.text "description", null: false
    t.string "heading", null: false
    t.integer "project_id"
    t.datetime "released", null: false
    t.datetime "updated_at", null: false
  end

  create_table "channels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_representatives", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_representatives_permissions", id: false, force: :cascade do |t|
    t.integer "client_representative_id"
    t.integer "permission_id"
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at"
    t.string "name", null: false
    t.datetime "updated_at"
  end

  create_table "comcast_customers", force: :cascade do |t|
    t.text "comments"
    t.datetime "created_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "location_id", null: false
    t.string "mobile_phone"
    t.string "other_phone"
    t.integer "person_id", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comcast_eods", force: :cascade do |t|
    t.boolean "cloud_training", default: false, null: false
    t.text "cloud_training_takeaway"
    t.boolean "comcast_visit", default: false, null: false
    t.text "comcast_visit_takeaway"
    t.datetime "created_at", null: false
    t.datetime "eod_date", null: false
    t.integer "location_id", null: false
    t.integer "person_id"
    t.boolean "sales_pro_visit", default: false, null: false
    t.text "sales_pro_visit_takeaway"
    t.datetime "updated_at", null: false
  end

  create_table "comcast_former_providers", force: :cascade do |t|
    t.integer "comcast_sale_id"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comcast_group_me_bots", force: :cascade do |t|
    t.integer "area_id"
    t.string "bot_num", null: false
    t.datetime "created_at", null: false
    t.string "group_num", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comcast_install_appointments", force: :cascade do |t|
    t.integer "comcast_install_time_slot_id", null: false
    t.integer "comcast_sale_id", null: false
    t.datetime "created_at", null: false
    t.date "install_date", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comcast_install_time_slots", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comcast_leads", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "comcast_customer_id", null: false
    t.text "comments"
    t.datetime "created_at", null: false
    t.date "follow_up_by"
    t.boolean "internet", default: false, null: false
    t.boolean "ok_to_call_and_text", default: false, null: false
    t.boolean "phone", default: false, null: false
    t.boolean "security", default: false, null: false
    t.boolean "tv", default: false, null: false
    t.datetime "updated_at", null: false
  end

  create_table "comcast_sales", force: :cascade do |t|
    t.integer "comcast_customer_id", null: false
    t.integer "comcast_former_provider_id"
    t.integer "comcast_lead_id"
    t.datetime "created_at", null: false
    t.boolean "customer_acknowledged", default: false, null: false
    t.boolean "internet", default: false, null: false
    t.date "order_date", null: false
    t.string "order_number", null: false
    t.integer "person_id", null: false
    t.boolean "phone", default: false, null: false
    t.boolean "security", default: false, null: false
    t.boolean "tv", default: false, null: false
    t.datetime "updated_at", null: false
  end

  create_table "communication_log_entries", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "loggable_id", null: false
    t.string "loggable_type", null: false
    t.integer "person_id", null: false
    t.datetime "updated_at"
  end

  create_table "day_sales_counts", force: :cascade do |t|
    t.integer "activations", default: 0, null: false
    t.datetime "created_at"
    t.date "day", null: false
    t.integer "new_accounts", default: 0, null: false
    t.integer "saleable_id", null: false
    t.string "saleable_type", null: false
    t.integer "sales", default: 0, null: false
    t.datetime "updated_at"
  end

  add_index "day_sales_counts", ["saleable_id", "saleable_type"], name: "index_day_sales_counts_on_saleable_id_and_saleable_type", using: :btree

  create_table "departments", force: :cascade do |t|
    t.boolean "corporate", null: false
    t.datetime "created_at"
    t.string "name", null: false
    t.datetime "updated_at"
  end

  create_table "device_deployments", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at"
    t.integer "device_id", null: false
    t.date "ended"
    t.integer "person_id", null: false
    t.date "started", null: false
    t.string "tracking_number"
    t.datetime "updated_at"
  end

  add_index "device_deployments", ["device_id"], name: "index_device_deployments_on_device_id", using: :btree
  add_index "device_deployments", ["person_id"], name: "index_device_deployments_on_person_id", using: :btree

  create_table "device_manufacturers", force: :cascade do |t|
    t.datetime "created_at"
    t.string "name", null: false
    t.datetime "updated_at"
  end

  create_table "device_models", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "device_manufacturer_id", null: false
    t.string "name", null: false
    t.datetime "updated_at"
  end

  add_index "device_models", ["device_manufacturer_id"], name: "index_device_models_on_device_manufacturer_id", using: :btree

  create_table "device_states", force: :cascade do |t|
    t.datetime "created_at"
    t.boolean "locked", default: false
    t.string "name", null: false
    t.datetime "updated_at"
  end

  create_table "device_states_devices", id: false, force: :cascade do |t|
    t.integer "device_id", null: false
    t.integer "device_state_id", null: false
  end

  add_index "device_states_devices", ["device_id"], name: "index_device_states_devices_on_device_id", using: :btree
  add_index "device_states_devices", ["device_state_id"], name: "index_device_states_devices_on_device_state_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "device_model_id", null: false
    t.string "identifier", null: false
    t.integer "line_id"
    t.integer "person_id"
    t.string "serial", null: false
    t.datetime "updated_at"
  end

  add_index "devices", ["device_model_id"], name: "index_devices_on_device_model_id", using: :btree
  add_index "devices", ["line_id"], name: "index_devices_on_line_id", using: :btree
  add_index "devices", ["person_id"], name: "index_devices_on_person_id", using: :btree

  create_table "docusign_noses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "eligible_to_rehire", default: false, null: false
    t.integer "employment_end_reason_id", null: false
    t.string "envelope_guid", null: false
    t.datetime "last_day_worked", null: false
    t.integer "person_id", null: false
    t.text "remarks"
    t.datetime "termination_date", null: false
    t.datetime "updated_at", null: false
  end

  create_table "docusign_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "document_type", default: 0, null: false
    t.integer "project_id", null: false
    t.string "state", limit: 2, null: false
    t.string "template_guid", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drop_off_reasons", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.boolean "eligible_for_reschedule", default: true, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_messages", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at"
    t.string "from_email", null: false
    t.string "subject", null: false
    t.string "to_email", null: false
    t.integer "to_person_id"
    t.datetime "updated_at"
  end

  create_table "employment_end_reasons", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employments", force: :cascade do |t|
    t.datetime "created_at"
    t.date "end"
    t.string "end_reason"
    t.integer "person_id"
    t.date "start"
    t.datetime "updated_at"
  end

  add_index "employments", ["person_id"], name: "index_employments_on_person_id", using: :btree

  create_table "group_me_groups", force: :cascade do |t|
    t.integer "area_id"
    t.string "avatar_url"
    t.string "bot_num"
    t.datetime "created_at"
    t.integer "group_num", null: false
    t.string "name", null: false
    t.datetime "updated_at"
  end

  add_index "group_me_groups", ["area_id"], name: "index_group_me_groups_on_area_id", using: :btree

  create_table "group_me_groups_group_me_users", id: false, force: :cascade do |t|
    t.integer "group_me_group_id", null: false
    t.integer "group_me_user_id", null: false
  end

  add_index "group_me_groups_group_me_users", ["group_me_group_id", "group_me_user_id"], name: "gm_groups_and_users", using: :btree
  add_index "group_me_groups_group_me_users", ["group_me_user_id", "group_me_group_id"], name: "gm_users_and_groups", using: :btree

  create_table "group_me_likes", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "group_me_post_id", null: false
    t.integer "group_me_user_id", null: false
    t.datetime "updated_at"
  end

  add_index "group_me_likes", ["group_me_post_id", "group_me_user_id"], name: "index_group_me_likes_on_group_me_post_id_and_group_me_user_id", using: :btree
  add_index "group_me_likes", ["group_me_post_id"], name: "index_group_me_likes_on_group_me_post_id", using: :btree
  add_index "group_me_likes", ["group_me_user_id", "group_me_post_id"], name: "index_group_me_likes_on_group_me_user_id_and_group_me_post_id", using: :btree
  add_index "group_me_likes", ["group_me_user_id"], name: "index_group_me_likes_on_group_me_user_id", using: :btree

  create_table "group_me_posts", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "group_me_group_id", null: false
    t.integer "group_me_user_id", null: false
    t.text "json", null: false
    t.integer "like_count", default: 0, null: false
    t.string "message_num", null: false
    t.integer "person_id"
    t.datetime "posted_at", null: false
    t.datetime "updated_at"
  end

  add_index "group_me_posts", ["group_me_group_id"], name: "index_group_me_posts_on_group_me_group_id", using: :btree
  add_index "group_me_posts", ["group_me_user_id"], name: "index_group_me_posts_on_group_me_user_id", using: :btree
  add_index "group_me_posts", ["person_id"], name: "index_group_me_posts_on_person_id", using: :btree

  create_table "group_me_users", force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at"
    t.string "group_me_user_num", null: false
    t.string "name", null: false
    t.integer "person_id"
    t.datetime "updated_at"
  end

  add_index "group_me_users", ["person_id"], name: "index_group_me_users_on_person_id", using: :btree

  create_table "interview_answers", force: :cascade do |t|
    t.integer "candidate_id"
    t.string "compensation_last_job_one", null: false
    t.string "compensation_last_job_three"
    t.string "compensation_last_job_two"
    t.string "compensation_seeking", null: false
    t.datetime "created_at", null: false
    t.string "hours_looking_to_work", null: false
    t.text "ideal_position", null: false
    t.text "last_two_positions", null: false
    t.text "personality_characteristic", null: false
    t.text "self_motivated_characteristic", null: false
    t.datetime "updated_at", null: false
    t.text "what_are_you_good_at", null: false
    t.text "what_are_you_not_good_at", null: false
    t.text "why_in_market", null: false
    t.text "willingness_characteristic", null: false
    t.text "work_history", null: false
  end

  create_table "interview_schedules", force: :cascade do |t|
    t.boolean "active"
    t.integer "candidate_id", null: false
    t.datetime "created_at", null: false
    t.date "interview_date"
    t.integer "person_id", null: false
    t.datetime "start_time", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_offer_details", force: :cascade do |t|
    t.integer "candidate_id", null: false
    t.datetime "completed"
    t.datetime "completed_by_advocate"
    t.datetime "completed_by_candidate"
    t.datetime "created_at", null: false
    t.string "envelope_guid"
    t.datetime "sent", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "person_id", null: false
    t.datetime "updated_at"
    t.integer "wall_post_id", null: false
  end

  add_index "likes", ["person_id"], name: "index_likes_on_person_id", using: :btree
  add_index "likes", ["wall_post_id"], name: "index_likes_on_wall_post_id", using: :btree

  create_table "line_states", force: :cascade do |t|
    t.datetime "created_at"
    t.boolean "locked", default: false
    t.string "name", null: false
    t.datetime "updated_at"
  end

  create_table "line_states_lines", id: false, force: :cascade do |t|
    t.integer "line_id", null: false
    t.integer "line_state_id", null: false
  end

  add_index "line_states_lines", ["line_id"], name: "index_line_states_lines_on_line_id", using: :btree
  add_index "line_states_lines", ["line_state_id"], name: "index_line_states_lines_on_line_state_id", using: :btree

  create_table "lines", force: :cascade do |t|
    t.date "contract_end_date", null: false
    t.datetime "created_at"
    t.string "identifier", null: false
    t.integer "technology_service_provider_id", null: false
    t.datetime "updated_at"
  end

  add_index "lines", ["technology_service_provider_id"], name: "index_lines_on_technology_service_provider_id", using: :btree

  create_table "link_posts", force: :cascade do |t|
    t.datetime "created_at"
    t.string "image_uid", null: false
    t.string "large_uid", null: false
    t.integer "person_id", null: false
    t.string "preview_uid", null: false
    t.integer "score", default: 0, null: false
    t.string "thumbnail_uid", null: false
    t.string "title"
    t.datetime "updated_at"
    t.string "url", null: false
  end

  add_index "link_posts", ["person_id"], name: "index_link_posts_on_person_id", using: :btree

  create_table "location_areas", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "area_id", null: false
    t.datetime "created_at", null: false
    t.integer "current_head_count", default: 0, null: false
    t.float "hourly_rate"
    t.integer "launch_group"
    t.integer "location_id", null: false
    t.integer "offer_extended_count", default: 0, null: false
    t.boolean "outsourced", default: false, null: false
    t.integer "potential_candidate_count", default: 0, null: false
    t.integer "target_head_count", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_areas_radio_shack_location_schedules", id: false, force: :cascade do |t|
    t.integer "location_area_id", null: false
    t.integer "radio_shack_location_schedule_id", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer "channel_id", null: false
    t.string "city", null: false
    t.string "cost_center"
    t.datetime "created_at", null: false
    t.string "display_name"
    t.float "latitude"
    t.float "longitude"
    t.string "mail_stop"
    t.integer "sprint_radio_shack_training_location_id"
    t.string "state", null: false
    t.string "store_number", null: false
    t.string "street_1"
    t.string "street_2"
    t.datetime "updated_at", null: false
    t.string "zip"
  end

  create_table "log_entries", force: :cascade do |t|
    t.string "action", null: false
    t.text "comment"
    t.datetime "created_at"
    t.integer "person_id", null: false
    t.integer "referenceable_id"
    t.string "referenceable_type"
    t.integer "trackable_id", null: false
    t.string "trackable_type", null: false
    t.datetime "updated_at"
  end

  add_index "log_entries", ["person_id"], name: "index_log_entries_on_person_id", using: :btree
  add_index "log_entries", ["referenceable_type", "referenceable_id"], name: "index_log_entries_on_referenceable_type_and_referenceable_id", using: :btree
  add_index "log_entries", ["trackable_type", "trackable_id"], name: "index_log_entries_on_trackable_type_and_trackable_id", using: :btree

  create_table "media", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "mediable_id", null: false
    t.string "mediable_type", null: false
    t.datetime "updated_at"
  end

  add_index "media", ["mediable_id", "mediable_type"], name: "index_media_on_mediable_id_and_mediable_type", using: :btree

  create_table "people", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "changelog_entry_id"
    t.string "connect_user_id"
    t.datetime "created_at"
    t.string "display_name", null: false
    t.integer "eid"
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "group_me_user_id"
    t.string "groupme_access_token"
    t.datetime "groupme_token_updated"
    t.string "home_phone"
    t.string "last_name", null: false
    t.datetime "last_seen"
    t.string "mobile_phone"
    t.string "office_phone"
    t.boolean "passed_asset_hours_requirement", default: false, null: false
    t.string "personal_email"
    t.integer "position_id"
    t.integer "sprint_prepaid_asset_approval_status", default: 0, null: false
    t.integer "supervisor_id"
    t.datetime "updated_at"
    t.integer "vonage_tablet_approval_status", default: 0, null: false
  end

  add_index "people", ["connect_user_id"], name: "index_people_on_connect_user_id", using: :btree
  add_index "people", ["group_me_user_id"], name: "index_people_on_group_me_user_id", using: :btree
  add_index "people", ["position_id"], name: "index_people_on_position_id", using: :btree
  add_index "people", ["supervisor_id"], name: "index_people_on_supervisor_id", using: :btree

  create_table "people_poll_question_choices", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "poll_question_choice_id", null: false
  end

  add_index "people_poll_question_choices", ["person_id", "poll_question_choice_id"], name: "ppqc_person_choice", using: :btree
  add_index "people_poll_question_choices", ["person_id"], name: "people_poll_choices_person", using: :btree
  add_index "people_poll_question_choices", ["poll_question_choice_id", "person_id"], name: "people_poll_choices_person_choice", using: :btree
  add_index "people_poll_question_choices", ["poll_question_choice_id", "person_id"], name: "ppqc_choice_person", using: :btree

  create_table "permission_groups", force: :cascade do |t|
    t.datetime "created_at"
    t.string "name", null: false
    t.datetime "updated_at"
  end

  create_table "permissions", force: :cascade do |t|
    t.datetime "created_at"
    t.string "description", null: false
    t.string "key", null: false
    t.integer "permission_group_id", null: false
    t.datetime "updated_at"
  end

  add_index "permissions", ["permission_group_id"], name: "index_permissions_on_permission_group_id", using: :btree

  create_table "permissions_positions", id: false, force: :cascade do |t|
    t.integer "permission_id", null: false
    t.integer "position_id", null: false
  end

  add_index "permissions_positions", ["permission_id", "position_id"], name: "index_permissions_positions_on_permission_id_and_position_id", using: :btree
  add_index "permissions_positions", ["permission_id"], name: "index_permissions_positions_on_permission_id", using: :btree
  add_index "permissions_positions", ["position_id", "permission_id"], name: "index_permissions_positions_on_position_id_and_permission_id", using: :btree
  add_index "permissions_positions", ["position_id"], name: "index_permissions_positions_on_position_id", using: :btree

  create_table "person_addresses", force: :cascade do |t|
    t.string "city", null: false
    t.datetime "created_at"
    t.float "latitude"
    t.string "line_1", null: false
    t.string "line_2"
    t.float "longitude"
    t.integer "person_id", null: false
    t.boolean "physical", default: true, null: false
    t.string "state", null: false
    t.datetime "updated_at"
    t.string "zip", null: false
  end

  create_table "person_areas", force: :cascade do |t|
    t.integer "area_id", null: false
    t.datetime "created_at"
    t.boolean "manages", default: false, null: false
    t.integer "person_id", null: false
    t.datetime "updated_at"
  end

  add_index "person_areas", ["area_id", "person_id"], name: "index_person_areas_on_area_id_and_person_id", using: :btree
  add_index "person_areas", ["area_id"], name: "index_person_areas_on_area_id", using: :btree
  add_index "person_areas", ["person_id"], name: "index_person_areas_on_person_id", using: :btree

  create_table "poll_question_choices", force: :cascade do |t|
    t.datetime "created_at"
    t.text "help_text"
    t.string "name", null: false
    t.integer "poll_question_id", null: false
    t.datetime "updated_at"
  end

  add_index "poll_question_choices", ["poll_question_id"], name: "index_poll_question_choices_on_poll_question_id", using: :btree

  create_table "poll_questions", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at"
    t.datetime "end_time"
    t.text "help_text"
    t.string "question", null: false
    t.datetime "start_time", null: false
    t.datetime "updated_at"
  end

  create_table "positions", force: :cascade do |t|
    t.boolean "all_corporate_visibility", null: false
    t.boolean "all_field_visibility", null: false
    t.datetime "created_at"
    t.integer "department_id", null: false
    t.boolean "field"
    t.boolean "hq"
    t.boolean "leadership", null: false
    t.string "name", null: false
    t.string "twilio_number"
    t.datetime "updated_at"
  end

  add_index "positions", ["department_id"], name: "index_positions_on_department_id", using: :btree

  create_table "prescreen_answers", force: :cascade do |t|
    t.boolean "can_work_weekends", default: false, null: false
    t.integer "candidate_id", null: false
    t.datetime "created_at", null: false
    t.boolean "eligible_smart_phone", default: false, null: false
    t.boolean "high_school_diploma", default: false, null: false
    t.boolean "of_age_to_work", default: false, null: false
    t.boolean "ok_to_screen", default: false, null: false
    t.boolean "reliable_transportation", default: false, null: false
    t.datetime "updated_at", null: false
    t.boolean "visible_tattoos", default: false, null: false
    t.boolean "worked_for_salesmakers", default: false, null: false
    t.boolean "worked_for_sprint", default: false, null: false
  end

  create_table "profile_educations", force: :cascade do |t|
    t.text "activities_societies"
    t.datetime "created_at"
    t.string "degree", null: false
    t.text "description"
    t.integer "end_year", null: false
    t.string "field_of_study", null: false
    t.integer "profile_id", null: false
    t.string "school", null: false
    t.integer "start_year", null: false
    t.datetime "updated_at"
  end

  add_index "profile_educations", ["profile_id"], name: "index_profile_educations_on_profile_id", using: :btree

  create_table "profile_experiences", force: :cascade do |t|
    t.string "company_name", null: false
    t.datetime "created_at"
    t.boolean "currently_employed"
    t.text "description"
    t.date "ended"
    t.string "location", null: false
    t.integer "profile_id", null: false
    t.date "started", null: false
    t.string "title", null: false
    t.datetime "updated_at"
  end

  add_index "profile_experiences", ["profile_id"], name: "index_profile_experiences_on_profile_id", using: :btree

  create_table "profile_skills", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "profile_id", null: false
    t.string "skill"
    t.datetime "updated_at"
  end

  add_index "profile_skills", ["profile_id"], name: "index_profile_skills_on_profile_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string "avatar_uid"
    t.text "bio"
    t.datetime "created_at"
    t.string "image_uid"
    t.text "interests"
    t.datetime "last_seen"
    t.string "nickname"
    t.integer "person_id", null: false
    t.string "theme_name"
    t.datetime "updated_at"
  end

  add_index "profiles", ["person_id"], name: "index_profiles_on_person_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "created_at"
    t.string "name", null: false
    t.datetime "updated_at"
    t.string "workmarket_project_num"
  end

  add_index "projects", ["client_id"], name: "index_projects_on_client_id", using: :btree

  create_table "publications", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "publishable_id", null: false
    t.string "publishable_type", null: false
    t.datetime "updated_at"
  end

  add_index "publications", ["publishable_id", "publishable_type"], name: "index_publications_on_publishable_id_and_publishable_type", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer "answer_id"
    t.text "content", null: false
    t.datetime "created_at"
    t.integer "person_id", null: false
    t.string "title", null: false
    t.datetime "updated_at"
  end

  add_index "questions", ["answer_id"], name: "index_questions_on_answer_id", using: :btree
  add_index "questions", ["person_id"], name: "index_questions_on_person_id", using: :btree

  create_table "radio_shack_location_schedules", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.float "friday", default: 0.0, null: false
    t.float "monday", default: 0.0, null: false
    t.string "name", null: false
    t.float "saturday", default: 0.0, null: false
    t.float "sunday", default: 0.0, null: false
    t.float "thursday", default: 0.0, null: false
    t.float "tuesday", default: 0.0, null: false
    t.datetime "updated_at", null: false
    t.float "wednesday", default: 0.0, null: false
  end

  create_table "sales_performance_ranks", force: :cascade do |t|
    t.datetime "created_at"
    t.date "day", null: false
    t.integer "day_rank"
    t.integer "month_rank"
    t.integer "rankable_id", null: false
    t.string "rankable_type", null: false
    t.datetime "updated_at"
    t.integer "week_rank"
    t.integer "year_rank"
  end

  add_index "sales_performance_ranks", ["rankable_id", "rankable_type"], name: "index_sales_performance_ranks_on_rankable_id_and_rankable_type", using: :btree

  create_table "screenings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "drug_screening", default: 0, null: false
    t.integer "person_id", null: false
    t.integer "private_background_check", default: 0, null: false
    t.integer "public_background_check", default: 0, null: false
    t.integer "sex_offender_check", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at"
    t.text "data"
    t.string "session_id", null: false
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "shifts", force: :cascade do |t|
    t.decimal "break_hours", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.decimal "hours", null: false
    t.integer "location_id"
    t.integer "person_id", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sms_messages", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "from_candidate_id"
    t.string "from_num", null: false
    t.integer "from_person_id"
    t.boolean "inbound", default: false
    t.text "message", null: false
    t.boolean "replied_to", default: false
    t.integer "reply_to_sms_message_id"
    t.string "sid", null: false
    t.integer "to_candidate_id"
    t.string "to_num", null: false
    t.integer "to_person_id"
    t.datetime "updated_at"
  end

  create_table "sprint_group_me_bots", force: :cascade do |t|
    t.integer "area_id", null: false
    t.string "bot_num", null: false
    t.datetime "created_at", null: false
    t.string "group_num", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sprint_pre_training_welcome_calls", force: :cascade do |t|
    t.integer "candidate_id", null: false
    t.boolean "cloud_confirmed", default: false, null: false
    t.boolean "cloud_reviewed", default: false, null: false
    t.text "comment"
    t.boolean "epay_confirmed", default: false, null: false
    t.boolean "epay_reviewed", default: false, null: false
    t.boolean "group_me_confirmed", default: false, null: false
    t.boolean "group_me_reviewed", default: false, null: false
    t.integer "status", default: 0, null: false
    t.boolean "still_able_to_attend", default: false, null: false
  end

  create_table "sprint_radio_shack_training_locations", force: :cascade do |t|
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "name", null: false
    t.string "room", null: false
    t.datetime "updated_at", null: false
    t.boolean "virtual", default: false, null: false
  end

  create_table "sprint_radio_shack_training_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sprint_sales", force: :cascade do |t|
    t.string "carrier_name", null: false
    t.text "comments"
    t.string "connect_sprint_sale_id"
    t.datetime "created_at", null: false
    t.string "handset_model_name", null: false
    t.integer "location_id", null: false
    t.string "meid", null: false
    t.string "mobile_phone"
    t.integer "person_id", null: false
    t.boolean "phone_activated_in_store", default: false, null: false
    t.string "picture_with_customer"
    t.string "rate_plan_name", null: false
    t.string "reason_not_activated_in_store"
    t.date "sale_date", null: false
    t.float "top_up_card_amount"
    t.boolean "top_up_card_purchased", default: false, null: false
    t.datetime "updated_at", null: false
    t.boolean "upgrade", default: false, null: false
  end

  create_table "technology_service_providers", force: :cascade do |t|
    t.datetime "created_at"
    t.string "name", null: false
    t.datetime "updated_at"
  end

  create_table "text_posts", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at"
    t.integer "person_id", null: false
    t.datetime "updated_at"
  end

  add_index "text_posts", ["person_id"], name: "index_text_posts_on_person_id", using: :btree

  create_table "themes", force: :cascade do |t|
    t.datetime "created_at"
    t.string "display_name", null: false
    t.string "name", null: false
    t.datetime "updated_at"
  end

  create_table "tmp_al", id: false, force: :cascade do |t|
    t.string "area"
    t.string "assessment"
  end

  create_table "tmp_all_sprint", id: false, force: :cascade do |t|
    t.string "address"
    t.string "store_num"
  end

  create_table "tmp_candidates", id: false, force: :cascade do |t|
    t.integer "cid"
    t.string "state"
  end

  create_table "tmp_em", id: false, force: :cascade do |t|
    t.string "email"
    t.string "username"
  end

  create_table "tmp_it", id: false, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "mobile_phone"
  end

  create_table "tmp_lg", id: false, force: :cascade do |t|
    t.string "cost_center"
    t.string "mail_stop"
    t.decimal "pay_rate"
    t.string "schedule"
    t.string "store_number"
    t.integer "target_head_count"
  end

  create_table "tmp_rates", id: false, force: :cascade do |t|
    t.decimal "hourly_rate"
    t.string "store_number"
  end

  create_table "tmp_sr", id: false, force: :cascade do |t|
    t.string "email"
    t.string "status"
  end

  create_table "tmp_tl", id: false, force: :cascade do |t|
    t.string "address"
    t.string "location_name"
    t.string "room"
    t.string "store_number"
  end

  create_table "tmp_uid", id: false, force: :cascade do |t|
    t.string "ad_user_id"
  end

  create_table "tmp_updates", id: false, force: :cascade do |t|
    t.string "address"
    t.string "cost_center"
    t.string "mailstop"
    t.string "store_name"
    t.string "store_num"
  end

  create_table "training_availabilities", force: :cascade do |t|
    t.boolean "able_to_attend", default: false, null: false
    t.integer "candidate_id", null: false
    t.text "comments"
    t.datetime "created_at", null: false
    t.integer "training_unavailability_reason_id"
    t.datetime "updated_at", null: false
  end

  create_table "training_class_attendees", force: :cascade do |t|
    t.boolean "attended", default: false, null: false
    t.text "conditional_pass_condition"
    t.datetime "created_at", null: false
    t.integer "drop_off_reason_id"
    t.datetime "dropped_off_time"
    t.boolean "group_me_setup", default: false, null: false
    t.integer "person_id", null: false
    t.integer "status", null: false
    t.boolean "time_clock_setup", default: false, null: false
    t.integer "training_class_id", null: false
    t.datetime "updated_at", null: false
  end

  create_table "training_class_types", force: :cascade do |t|
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.integer "max_attendance"
    t.string "name", null: false
    t.integer "project_id", null: false
    t.datetime "updated_at", null: false
  end

  add_index "training_class_types", ["ancestry"], name: "index_training_class_types_on_ancestry", using: :btree

  create_table "training_classes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date"
    t.integer "person_id"
    t.integer "training_class_type_id"
    t.integer "training_time_slot_id"
    t.datetime "updated_at", null: false
  end

  create_table "training_time_slots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_date", null: false
    t.boolean "friday", default: false, null: false
    t.boolean "monday", default: false, null: false
    t.integer "person_id", null: false
    t.boolean "saturday", default: false, null: false
    t.datetime "start_date", null: false
    t.boolean "sunday", default: false, null: false
    t.boolean "thursday", default: false, null: false
    t.integer "training_class_type_id", null: false
    t.boolean "tuesday", default: false, null: false
    t.datetime "updated_at", null: false
    t.boolean "wednesday", default: false, null: false
  end

  create_table "training_unavailability_reasons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unmatched_candidates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.float "score", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploaded_images", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at"
    t.string "image_uid", null: false
    t.string "large_uid", null: false
    t.integer "person_id", null: false
    t.string "preview_uid", null: false
    t.integer "score", default: 0, null: false
    t.string "thumbnail_uid", null: false
    t.datetime "updated_at"
  end

  add_index "uploaded_images", ["person_id"], name: "index_uploaded_images_on_person_id", using: :btree

  create_table "uploaded_videos", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "person_id", null: false
    t.integer "score", default: 0, null: false
    t.datetime "updated_at"
    t.string "url", null: false
  end

  add_index "uploaded_videos", ["person_id"], name: "index_uploaded_videos_on_person_id", using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "foreign_key_id"
    t.string "foreign_key_name", null: false
    t.integer "version_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.text "object"
    t.integer "transaction_id"
    t.string "whodunnit"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  create_table "vonage_account_status_changes", force: :cascade do |t|
    t.date "account_end_date"
    t.date "account_start_date", null: false
    t.datetime "created_at", null: false
    t.string "mac", null: false
    t.integer "status", null: false
    t.string "termination_reason"
    t.datetime "updated_at", null: false
  end

  create_table "vonage_paycheck_negative_balances", force: :cascade do |t|
    t.decimal "balance", null: false
    t.datetime "created_at", null: false
    t.integer "person_id", null: false
    t.datetime "updated_at", null: false
    t.integer "vonage_paycheck_id", null: false
  end

  create_table "vonage_paychecks", force: :cascade do |t|
    t.date "commission_end", null: false
    t.date "commission_start", null: false
    t.datetime "created_at", null: false
    t.datetime "cutoff", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.date "wages_end", null: false
    t.date "wages_start", null: false
  end

  create_table "vonage_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.decimal "price_range_maximum", default: 9999.99, null: false
    t.decimal "price_range_minimum", default: 0.0, null: false
    t.datetime "updated_at", null: false
  end

  create_table "vonage_refunds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "person_id", null: false
    t.date "refund_date", null: false
    t.datetime "updated_at", null: false
    t.integer "vonage_account_status_change_id", null: false
    t.integer "vonage_sale_id", null: false
  end

  create_table "vonage_rep_sale_payout_brackets", force: :cascade do |t|
    t.integer "area_id", null: false
    t.datetime "created_at", null: false
    t.decimal "per_sale", null: false
    t.integer "sales_maximum", null: false
    t.integer "sales_minimum", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vonage_sale_payouts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "day_122", default: false, null: false
    t.boolean "day_152", default: false, null: false
    t.boolean "day_62", default: false, null: false
    t.boolean "day_92", default: false, null: false
    t.decimal "payout", null: false
    t.integer "person_id", null: false
    t.datetime "updated_at", null: false
    t.integer "vonage_paycheck_id", null: false
    t.integer "vonage_sale_id", null: false
  end

  create_table "vonage_sales", force: :cascade do |t|
    t.string "confirmation_number", null: false
    t.string "connect_order_uuid"
    t.datetime "created_at", null: false
    t.string "customer_first_name", null: false
    t.string "customer_last_name", null: false
    t.integer "location_id", null: false
    t.string "mac", null: false
    t.integer "person_id", null: false
    t.boolean "resold", default: false, null: false
    t.date "sale_date", null: false
    t.datetime "updated_at", null: false
    t.integer "vonage_product_id", null: false
  end

  create_table "wall_post_comments", force: :cascade do |t|
    t.text "comment", null: false
    t.datetime "created_at"
    t.integer "person_id", null: false
    t.datetime "updated_at"
    t.integer "wall_post_id", null: false
  end

  add_index "wall_post_comments", ["person_id"], name: "index_wall_post_comments_on_person_id", using: :btree
  add_index "wall_post_comments", ["wall_post_id"], name: "index_wall_post_comments_on_wall_post_id", using: :btree

  create_table "wall_posts", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "person_id", null: false
    t.integer "publication_id", null: false
    t.integer "reposted_by_person_id"
    t.datetime "updated_at"
    t.integer "wall_id", null: false
  end

  add_index "wall_posts", ["person_id"], name: "index_wall_posts_on_person_id", using: :btree
  add_index "wall_posts", ["publication_id"], name: "index_wall_posts_on_publication_id", using: :btree
  add_index "wall_posts", ["reposted_by_person_id"], name: "index_wall_posts_on_reposted_by_person_id", using: :btree
  add_index "wall_posts", ["wall_id"], name: "index_wall_posts_on_wall_id", using: :btree

  create_table "walls", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "wallable_id", null: false
    t.string "wallable_type", null: false
  end

  add_index "walls", ["wallable_id", "wallable_type"], name: "index_walls_on_wallable_id_and_wallable_type", using: :btree

  create_table "workmarket_assignments", force: :cascade do |t|
    t.float "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "ended", null: false
    t.text "json", null: false
    t.integer "project_id", null: false
    t.datetime "started", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "worker_email", null: false
    t.string "worker_first_name"
    t.string "worker_last_name"
    t.string "worker_name", null: false
    t.string "workmarket_assignment_num", null: false
    t.string "workmarket_location_num", null: false
  end

  create_table "workmarket_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "guid", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.integer "workmarket_assignment_id", null: false
  end

  create_table "workmarket_fields", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.integer "workmarket_assignment_id", null: false
  end

  create_table "workmarket_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location_number"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "workmarket_location_num", null: false
  end
end
