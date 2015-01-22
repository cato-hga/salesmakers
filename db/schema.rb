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

ActiveRecord::Schema.define(version: 20150122213446) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_upvotes", force: :cascade do |t|
    t.integer  "answer_id",  null: false
    t.integer  "person_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_upvotes", ["answer_id"], name: "index_answer_upvotes_on_answer_id", using: :btree
  add_index "answer_upvotes", ["person_id"], name: "index_answer_upvotes_on_person_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "person_id",   null: false
    t.integer  "question_id", null: false
    t.text     "content",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["person_id"], name: "index_answers_on_person_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "area_types", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "project_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "area_types", ["project_id"], name: "index_area_types_on_project_id", using: :btree

  create_table "areas", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "area_type_id", null: false
    t.string "ancestry", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "project_id", null: false
    t.string "groupme_group", limit: 255
    t.string "connect_salesregion_id", limit: 255
  end

  add_index "areas", ["ancestry"], name: "index_areas_on_ancestry", using: :btree
  add_index "areas", ["area_type_id"], name: "index_areas_on_area_type_id", using: :btree
  add_index "areas", ["project_id"], name: "index_areas_on_project_id", using: :btree

  create_table "blog_posts", force: :cascade do |t|
    t.integer "person_id", null: false
    t.text "excerpt", null: false
    t.text "content", null: false
    t.string "title", limit: 255, null: false
    t.integer "score", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_posts", ["person_id"], name: "index_blog_posts_on_person_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comcast_customers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "mobile_phone"
    t.string "other_phone"
    t.integer "person_id"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comcast_sales", force: :cascade do |t|
    t.datetime "sale_date"
    t.integer "person_id"
    t.integer "comcast_customer_id"
    t.string "order_number"
    t.boolean "tv"
    t.boolean "internet"
    t.boolean "phone"
    t.boolean "security"
    t.boolean "customer_acknowledged"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "communication_log_entries", force: :cascade do |t|
    t.integer "loggable_id", null: false
    t.string "loggable_type", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "person_id", null: false
  end

  create_table "day_sales_counts", force: :cascade do |t|
    t.date "day", null: false
    t.integer "saleable_id", null: false
    t.string "saleable_type", limit: 255, null: false
    t.integer "sales", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "day_sales_counts", ["saleable_id", "saleable_type"], name: "index_day_sales_counts_on_saleable_id_and_saleable_type", using: :btree

  create_table "departments", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.boolean "corporate", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_deployments", force: :cascade do |t|
    t.integer "device_id", null: false
    t.integer "person_id", null: false
    t.date "started", null: false
    t.date     "ended"
    t.string "tracking_number", limit: 255
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "device_deployments", ["device_id"], name: "index_device_deployments_on_device_id", using: :btree
  add_index "device_deployments", ["person_id"], name: "index_device_deployments_on_person_id", using: :btree

  create_table "device_manufacturers", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_models", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "device_manufacturer_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "device_models", ["device_manufacturer_id"], name: "index_device_models_on_device_manufacturer_id", using: :btree

  create_table "device_states", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "locked", default: false
  end

  create_table "device_states_devices", id: false, force: :cascade do |t|
    t.integer "device_id",       null: false
    t.integer "device_state_id", null: false
  end

  add_index "device_states_devices", ["device_id"], name: "index_device_states_devices_on_device_id", using: :btree
  add_index "device_states_devices", ["device_state_id"], name: "index_device_states_devices_on_device_state_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string "identifier", limit: 255, null: false
    t.string "serial", limit: 255, null: false
    t.integer "device_model_id", null: false
    t.integer  "line_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["device_model_id"], name: "index_devices_on_device_model_id", using: :btree
  add_index "devices", ["line_id"], name: "index_devices_on_line_id", using: :btree
  add_index "devices", ["person_id"], name: "index_devices_on_person_id", using: :btree

  create_table "email_messages", force: :cascade do |t|
    t.string "from_email", limit: 255, null: false
    t.string "to_email", limit: 255, null: false
    t.integer  "to_person_id"
    t.text "content", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "subject", limit: 255, null: false
  end

  create_table "employments", force: :cascade do |t|
    t.integer  "person_id"
    t.date     "start"
    t.date     "end"
    t.string "end_reason", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employments", ["person_id"], name: "index_employments_on_person_id", using: :btree

  create_table "group_me_groups", force: :cascade do |t|
    t.integer "group_num", null: false
    t.integer  "area_id"
    t.string "name", limit: 255, null: false
    t.string "avatar_url", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_me_groups", ["area_id"], name: "index_group_me_groups_on_area_id", using: :btree

  create_table "group_me_groups_group_me_users", id: false, force: :cascade do |t|
    t.integer "group_me_group_id", null: false
    t.integer "group_me_user_id",  null: false
  end

  add_index "group_me_groups_group_me_users", ["group_me_group_id", "group_me_user_id"], name: "gm_groups_and_users", using: :btree
  add_index "group_me_groups_group_me_users", ["group_me_group_id"], name: "index_group_me_groups_group_me_users_on_group_me_group_id", using: :btree
  add_index "group_me_groups_group_me_users", ["group_me_user_id", "group_me_group_id"], name: "gm_users_and_groups", using: :btree
  add_index "group_me_groups_group_me_users", ["group_me_user_id"], name: "index_group_me_groups_group_me_users_on_group_me_user_id", using: :btree

  create_table "group_me_likes", force: :cascade do |t|
    t.integer  "group_me_user_id", null: false
    t.integer  "group_me_post_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_me_likes", ["group_me_post_id", "group_me_user_id"], name: "index_group_me_likes_on_group_me_post_id_and_group_me_user_id", using: :btree
  add_index "group_me_likes", ["group_me_post_id"], name: "index_group_me_likes_on_group_me_post_id", using: :btree
  add_index "group_me_likes", ["group_me_user_id", "group_me_post_id"], name: "index_group_me_likes_on_group_me_user_id_and_group_me_post_id", using: :btree
  add_index "group_me_likes", ["group_me_user_id"], name: "index_group_me_likes_on_group_me_user_id", using: :btree

  create_table "group_me_posts", force: :cascade do |t|
    t.integer "group_me_group_id", null: false
    t.datetime "posted_at", null: false
    t.text "json", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "group_me_user_id", null: false
    t.string "message_num", limit: 255, null: false
    t.integer "like_count", default: 0, null: false
    t.integer  "person_id"
  end

  add_index "group_me_posts", ["group_me_group_id"], name: "index_group_me_posts_on_group_me_group_id", using: :btree
  add_index "group_me_posts", ["group_me_user_id"], name: "index_group_me_posts_on_group_me_user_id", using: :btree
  add_index "group_me_posts", ["person_id"], name: "index_group_me_posts_on_person_id", using: :btree

  create_table "group_me_users", force: :cascade do |t|
    t.string "group_me_user_num", limit: 255, null: false
    t.integer  "person_id"
    t.string "name", limit: 255, null: false
    t.string "avatar_url", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_me_users", ["person_id"], name: "index_group_me_users_on_person_id", using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "person_id",    null: false
    t.integer  "wall_post_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["person_id"], name: "index_likes_on_person_id", using: :btree
  add_index "likes", ["wall_post_id"], name: "index_likes_on_wall_post_id", using: :btree

  create_table "line_states", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "locked", default: false
  end

  create_table "line_states_lines", id: false, force: :cascade do |t|
    t.integer "line_id",       null: false
    t.integer "line_state_id", null: false
  end

  add_index "line_states_lines", ["line_id"], name: "index_line_states_lines_on_line_id", using: :btree
  add_index "line_states_lines", ["line_state_id"], name: "index_line_states_lines_on_line_state_id", using: :btree

  create_table "lines", force: :cascade do |t|
    t.string "identifier", limit: 255, null: false
    t.date "contract_end_date", null: false
    t.integer "technology_service_provider_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lines", ["technology_service_provider_id"], name: "index_lines_on_technology_service_provider_id", using: :btree

  create_table "link_posts", force: :cascade do |t|
    t.string "image_uid", limit: 255, null: false
    t.string "thumbnail_uid", limit: 255, null: false
    t.string "preview_uid", limit: 255, null: false
    t.string "large_uid", limit: 255, null: false
    t.integer "person_id", null: false
    t.string "title", limit: 255
    t.integer "score", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "url", limit: 255, null: false
  end

  add_index "link_posts", ["person_id"], name: "index_link_posts_on_person_id", using: :btree

  create_table "log_entries", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "action", limit: 255, null: false
    t.text     "comment"
    t.integer "trackable_id", null: false
    t.string "trackable_type", limit: 255, null: false
    t.integer  "referenceable_id"
    t.string "referenceable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "log_entries", ["person_id"], name: "index_log_entries_on_person_id", using: :btree
  add_index "log_entries", ["referenceable_id", "referenceable_type"], name: "index_log_entries_on_referenceable_id_and_referenceable_type", using: :btree
  add_index "log_entries", ["trackable_id", "trackable_type"], name: "index_log_entries_on_trackable_id_and_trackable_type", using: :btree

  create_table "media", force: :cascade do |t|
    t.integer "mediable_id", null: false
    t.string "mediable_type", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media", ["mediable_id", "mediable_type"], name: "index_media_on_mediable_id_and_mediable_type", using: :btree

  create_table "people", force: :cascade do |t|
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.string "display_name", limit: 255, null: false
    t.string "email", limit: 255, null: false
    t.string "personal_email", limit: 255
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "active", default: true, null: false
    t.string "connect_user_id", limit: 255
    t.integer  "supervisor_id"
    t.string "office_phone", limit: 255
    t.string "mobile_phone", limit: 255
    t.string "home_phone", limit: 255
    t.integer  "eid"
    t.string "groupme_access_token", limit: 255
    t.datetime "groupme_token_updated"
    t.string "group_me_user_id", limit: 255
    t.datetime "last_seen"
  end

  add_index "people", ["connect_user_id"], name: "index_people_on_connect_user_id", using: :btree
  add_index "people", ["group_me_user_id"], name: "index_people_on_group_me_user_id", using: :btree
  add_index "people", ["position_id"], name: "index_people_on_position_id", using: :btree
  add_index "people", ["supervisor_id"], name: "index_people_on_supervisor_id", using: :btree

  create_table "people_poll_question_choices", id: false, force: :cascade do |t|
    t.integer "person_id",               null: false
    t.integer "poll_question_choice_id", null: false
  end

  add_index "people_poll_question_choices", ["person_id", "poll_question_choice_id"], name: "ppqc_person_choice", using: :btree
  add_index "people_poll_question_choices", ["person_id"], name: "people_poll_choices_person", using: :btree
  add_index "people_poll_question_choices", ["poll_question_choice_id", "person_id"], name: "people_poll_choices_person_choice", using: :btree
  add_index "people_poll_question_choices", ["poll_question_choice_id", "person_id"], name: "ppqc_choice_person", using: :btree

  create_table "permission_groups", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "key", limit: 255, null: false
    t.string "description", limit: 255, null: false
    t.integer "permission_group_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["permission_group_id"], name: "index_permissions_on_permission_group_id", using: :btree

  create_table "permissions_positions", id: false, force: :cascade do |t|
    t.integer "permission_id", null: false
    t.integer "position_id",   null: false
  end

  add_index "permissions_positions", ["permission_id", "position_id"], name: "index_permissions_positions_on_permission_id_and_position_id", using: :btree
  add_index "permissions_positions", ["permission_id"], name: "index_permissions_positions_on_permission_id", using: :btree
  add_index "permissions_positions", ["position_id", "permission_id"], name: "index_permissions_positions_on_position_id_and_permission_id", using: :btree
  add_index "permissions_positions", ["position_id"], name: "index_permissions_positions_on_position_id", using: :btree

  create_table "person_addresses", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "line_1", limit: 255, null: false
    t.string "line_2", limit: 255
    t.string "city", limit: 255, null: false
    t.string "state", limit: 255, null: false
    t.string "zip", limit: 255, null: false
    t.boolean "physical", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "person_areas", force: :cascade do |t|
    t.integer  "person_id",                  null: false
    t.integer  "area_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "manages",    default: false, null: false
  end

  add_index "person_areas", ["area_id", "person_id"], name: "index_person_areas_on_area_id_and_person_id", using: :btree
  add_index "person_areas", ["area_id"], name: "index_person_areas_on_area_id", using: :btree
  add_index "person_areas", ["person_id"], name: "index_person_areas_on_person_id", using: :btree

  create_table "poll_question_choices", force: :cascade do |t|
    t.integer "poll_question_id", null: false
    t.string "name", limit: 255, null: false
    t.text     "help_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poll_question_choices", ["poll_question_id"], name: "index_poll_question_choices_on_poll_question_id", using: :btree

  create_table "poll_questions", force: :cascade do |t|
    t.string "question", limit: 255, null: false
    t.text     "help_text"
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.boolean "active", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.boolean "leadership", null: false
    t.boolean "all_field_visibility", null: false
    t.boolean "all_corporate_visibility", null: false
    t.integer "department_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "field"
    t.boolean  "hq"
    t.string "twilio_number", limit: 255
  end

  add_index "positions", ["department_id"], name: "index_positions_on_department_id", using: :btree

  create_table "profile_educations", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.string "school", limit: 255, null: false
    t.integer "start_year", null: false
    t.integer "end_year", null: false
    t.string "degree", limit: 255, null: false
    t.string "field_of_study", limit: 255, null: false
    t.text     "activities_societies"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_educations", ["profile_id"], name: "index_profile_educations_on_profile_id", using: :btree

  create_table "profile_experiences", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.string "company_name", limit: 255, null: false
    t.string "title", limit: 255, null: false
    t.string "location", limit: 255, null: false
    t.date "started", null: false
    t.date     "ended"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "currently_employed"
  end

  add_index "profile_experiences", ["profile_id"], name: "index_profile_experiences_on_profile_id", using: :btree

  create_table "profile_skills", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.string "skill", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_skills", ["profile_id"], name: "index_profile_skills_on_profile_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "theme_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "interests"
    t.text     "bio"
    t.string "avatar_uid", limit: 255
    t.string "image_uid", limit: 255
    t.string "nickname", limit: 255
    t.datetime "last_seen"
  end

  add_index "profiles", ["person_id"], name: "index_profiles_on_person_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "client_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["client_id"], name: "index_projects_on_client_id", using: :btree

  create_table "publications", force: :cascade do |t|
    t.integer "publishable_id", null: false
    t.string "publishable_type", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publications", ["publishable_id", "publishable_type"], name: "index_publications_on_publishable_id_and_publishable_type", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer  "answer_id"
    t.string "title", limit: 255, null: false
    t.text "content", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["answer_id"], name: "index_questions_on_answer_id", using: :btree
  add_index "questions", ["person_id"], name: "index_questions_on_person_id", using: :btree

  create_table "sales_performance_ranks", force: :cascade do |t|
    t.date "day", null: false
    t.integer "rankable_id", null: false
    t.string "rankable_type", limit: 255, null: false
    t.integer  "day_rank"
    t.integer  "week_rank"
    t.integer  "month_rank"
    t.integer  "year_rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sales_performance_ranks", ["rankable_id", "rankable_type"], name: "index_sales_performance_ranks_on_rankable_id_and_rankable_type", using: :btree

  create_table "sms_messages", force: :cascade do |t|
    t.string "from_num", limit: 255, null: false
    t.string "to_num", limit: 255, null: false
    t.integer  "from_person_id"
    t.integer  "to_person_id"
    t.boolean "inbound", default: false
    t.integer  "reply_to_sms_message_id"
    t.boolean "replied_to", default: false
    t.text "message", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "sid", limit: 255, null: false
  end

  create_table "technology_service_providers", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "text_posts", force: :cascade do |t|
    t.integer  "person_id",  null: false
    t.text     "content",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "text_posts", ["person_id"], name: "index_text_posts_on_person_id", using: :btree

  create_table "themes", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "display_name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploaded_images", force: :cascade do |t|
    t.string "image_uid", limit: 255, null: false
    t.string "thumbnail_uid", limit: 255, null: false
    t.string "preview_uid", limit: 255, null: false
    t.string "large_uid", limit: 255, null: false
    t.integer "person_id", null: false
    t.string "caption", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "score", default: 0, null: false
  end

  add_index "uploaded_images", ["person_id"], name: "index_uploaded_images_on_person_id", using: :btree

  create_table "uploaded_videos", force: :cascade do |t|
    t.string "url", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "person_id", null: false
    t.integer "score", default: 0, null: false
  end

  add_index "uploaded_videos", ["person_id"], name: "index_uploaded_videos_on_person_id", using: :btree

  create_table "wall_post_comments", force: :cascade do |t|
    t.integer  "wall_post_id", null: false
    t.integer  "person_id",    null: false
    t.text     "comment",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wall_post_comments", ["person_id"], name: "index_wall_post_comments_on_person_id", using: :btree
  add_index "wall_post_comments", ["wall_post_id"], name: "index_wall_post_comments_on_wall_post_id", using: :btree

  create_table "wall_posts", force: :cascade do |t|
    t.integer  "publication_id",        null: false
    t.integer  "wall_id",               null: false
    t.integer  "person_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reposted_by_person_id"
  end

  add_index "wall_posts", ["person_id"], name: "index_wall_posts_on_person_id", using: :btree
  add_index "wall_posts", ["publication_id"], name: "index_wall_posts_on_publication_id", using: :btree
  add_index "wall_posts", ["reposted_by_person_id"], name: "index_wall_posts_on_reposted_by_person_id", using: :btree
  add_index "wall_posts", ["wall_id"], name: "index_wall_posts_on_wall_id", using: :btree

  create_table "walls", force: :cascade do |t|
    t.integer "wallable_id", null: false
    t.string "wallable_type", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "walls", ["wallable_id", "wallable_type"], name: "index_walls_on_wallable_id_and_wallable_type", using: :btree

end
