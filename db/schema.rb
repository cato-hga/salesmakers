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

ActiveRecord::Schema.define(version: 20141111205604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_upvotes", force: true do |t|
    t.integer  "answer_id",  null: false
    t.integer  "person_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_upvotes", ["answer_id"], name: "index_answer_upvotes_on_answer_id", using: :btree
  add_index "answer_upvotes", ["person_id"], name: "index_answer_upvotes_on_person_id", using: :btree

  create_table "answers", force: true do |t|
    t.integer  "person_id",   null: false
    t.integer  "question_id", null: false
    t.text     "content",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["person_id"], name: "index_answers_on_person_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "area_types", force: true do |t|
    t.string   "name",       null: false
    t.integer  "project_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "area_types", ["project_id"], name: "index_area_types_on_project_id", using: :btree

  create_table "areas", force: true do |t|
    t.string   "name",                   null: false
    t.integer  "area_type_id",           null: false
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id",             null: false
    t.string   "groupme_group"
    t.string   "connect_salesregion_id"
  end

  add_index "areas", ["ancestry"], name: "index_areas_on_ancestry", using: :btree
  add_index "areas", ["area_type_id"], name: "index_areas_on_area_type_id", using: :btree
  add_index "areas", ["project_id"], name: "index_areas_on_project_id", using: :btree

  create_table "blog_posts", force: true do |t|
    t.integer  "person_id",              null: false
    t.text     "excerpt",                null: false
    t.text     "content",                null: false
    t.string   "title",                  null: false
    t.integer  "score",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_posts", ["person_id"], name: "index_blog_posts_on_person_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "day_sales_counts", force: true do |t|
    t.date     "day",                       null: false
    t.integer  "saleable_id",               null: false
    t.string   "saleable_type",             null: false
    t.integer  "sales",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "day_sales_counts", ["saleable_id", "saleable_type"], name: "index_day_sales_counts_on_saleable_id_and_saleable_type", using: :btree

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

  add_index "device_deployments", ["device_id"], name: "index_device_deployments_on_device_id", using: :btree
  add_index "device_deployments", ["person_id"], name: "index_device_deployments_on_person_id", using: :btree

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

  add_index "device_models", ["device_manufacturer_id"], name: "index_device_models_on_device_manufacturer_id", using: :btree

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
    t.string   "identifier",           null: false
    t.string   "serial",               null: false
    t.integer  "device_model_id",      null: false
    t.integer  "line_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "secondary_identifier"
  end

  add_index "devices", ["device_model_id"], name: "index_devices_on_device_model_id", using: :btree
  add_index "devices", ["line_id"], name: "index_devices_on_line_id", using: :btree
  add_index "devices", ["person_id"], name: "index_devices_on_person_id", using: :btree

  create_table "employments", force: true do |t|
    t.integer  "person_id"
    t.date     "start"
    t.date     "end"
    t.string   "end_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employments", ["person_id"], name: "index_employments_on_person_id", using: :btree

  create_table "group_me_groups", force: true do |t|
    t.integer  "group_num",  null: false
    t.integer  "area_id"
    t.string   "name",       null: false
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_me_groups", ["area_id"], name: "index_group_me_groups_on_area_id", using: :btree

  create_table "group_me_groups_group_me_users", id: false, force: true do |t|
    t.integer "group_me_group_id", null: false
    t.integer "group_me_user_id",  null: false
  end

  add_index "group_me_groups_group_me_users", ["group_me_group_id", "group_me_user_id"], name: "gm_groups_and_users", using: :btree
  add_index "group_me_groups_group_me_users", ["group_me_group_id"], name: "index_group_me_groups_group_me_users_on_group_me_group_id", using: :btree
  add_index "group_me_groups_group_me_users", ["group_me_user_id", "group_me_group_id"], name: "gm_users_and_groups", using: :btree
  add_index "group_me_groups_group_me_users", ["group_me_user_id"], name: "index_group_me_groups_group_me_users_on_group_me_user_id", using: :btree

  create_table "group_me_likes", force: true do |t|
    t.integer  "group_me_user_id", null: false
    t.integer  "group_me_post_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_me_likes", ["group_me_post_id", "group_me_user_id"], name: "index_group_me_likes_on_group_me_post_id_and_group_me_user_id", using: :btree
  add_index "group_me_likes", ["group_me_post_id"], name: "index_group_me_likes_on_group_me_post_id", using: :btree
  add_index "group_me_likes", ["group_me_user_id", "group_me_post_id"], name: "index_group_me_likes_on_group_me_user_id_and_group_me_post_id", using: :btree
  add_index "group_me_likes", ["group_me_user_id"], name: "index_group_me_likes_on_group_me_user_id", using: :btree

  create_table "group_me_posts", force: true do |t|
    t.integer  "group_me_group_id",             null: false
    t.datetime "posted_at",                     null: false
    t.text     "json",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_me_user_id",              null: false
    t.string   "message_num",                   null: false
    t.integer  "like_count",        default: 0, null: false
    t.integer  "person_id"
  end

  add_index "group_me_posts", ["group_me_group_id"], name: "index_group_me_posts_on_group_me_group_id", using: :btree
  add_index "group_me_posts", ["group_me_user_id"], name: "index_group_me_posts_on_group_me_user_id", using: :btree
  add_index "group_me_posts", ["person_id"], name: "index_group_me_posts_on_person_id", using: :btree

  create_table "group_me_users", force: true do |t|
    t.string   "group_me_user_num", null: false
    t.integer  "person_id"
    t.string   "name",              null: false
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_me_users", ["person_id"], name: "index_group_me_users_on_person_id", using: :btree

  create_table "likes", force: true do |t|
    t.integer  "person_id",    null: false
    t.integer  "wall_post_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["person_id"], name: "index_likes_on_person_id", using: :btree
  add_index "likes", ["wall_post_id"], name: "index_likes_on_wall_post_id", using: :btree

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

  add_index "lines", ["technology_service_provider_id"], name: "index_lines_on_technology_service_provider_id", using: :btree

  create_table "link_posts", force: true do |t|
    t.string   "image_uid",                 null: false
    t.string   "thumbnail_uid",             null: false
    t.string   "preview_uid",               null: false
    t.string   "large_uid",                 null: false
    t.integer  "person_id",                 null: false
    t.string   "title"
    t.integer  "score",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url",                       null: false
  end

  add_index "link_posts", ["person_id"], name: "index_link_posts_on_person_id", using: :btree

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

  create_table "media", force: true do |t|
    t.integer  "mediable_id",   null: false
    t.string   "mediable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media", ["mediable_id", "mediable_type"], name: "index_media_on_mediable_id_and_mediable_type", using: :btree

  create_table "people", force: true do |t|
    t.string   "first_name",                           null: false
    t.string   "last_name",                            null: false
    t.string   "display_name"
    t.string   "email",                                null: false
    t.string   "personal_email"
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                default: true, null: false
    t.string   "connect_user_id"
    t.integer  "supervisor_id"
    t.string   "office_phone"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.integer  "eid"
    t.string   "groupme_access_token"
    t.datetime "groupme_token_updated"
    t.string   "group_me_user_id"
    t.datetime "last_seen"
  end

  add_index "people", ["connect_user_id"], name: "index_people_on_connect_user_id", using: :btree
  add_index "people", ["group_me_user_id"], name: "index_people_on_group_me_user_id", using: :btree
  add_index "people", ["position_id"], name: "index_people_on_position_id", using: :btree
  add_index "people", ["supervisor_id"], name: "index_people_on_supervisor_id", using: :btree

  create_table "people_poll_question_choices", id: false, force: true do |t|
    t.integer "person_id",               null: false
    t.integer "poll_question_choice_id", null: false
  end

  add_index "people_poll_question_choices", ["person_id", "poll_question_choice_id"], name: "ppqc_person_choice", using: :btree
  add_index "people_poll_question_choices", ["person_id"], name: "people_poll_choices_person", using: :btree
  add_index "people_poll_question_choices", ["poll_question_choice_id", "person_id"], name: "people_poll_choices_person_choice", using: :btree
  add_index "people_poll_question_choices", ["poll_question_choice_id", "person_id"], name: "ppqc_choice_person", using: :btree

  create_table "permission_groups", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.string   "key",                 null: false
    t.string   "description",         null: false
    t.integer  "permission_group_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["permission_group_id"], name: "index_permissions_on_permission_group_id", using: :btree

  create_table "permissions_positions", id: false, force: true do |t|
    t.integer "permission_id", null: false
    t.integer "position_id",   null: false
  end

  add_index "permissions_positions", ["permission_id", "position_id"], name: "index_permissions_positions_on_permission_id_and_position_id", using: :btree
  add_index "permissions_positions", ["permission_id"], name: "index_permissions_positions_on_permission_id", using: :btree
  add_index "permissions_positions", ["position_id", "permission_id"], name: "index_permissions_positions_on_position_id_and_permission_id", using: :btree
  add_index "permissions_positions", ["position_id"], name: "index_permissions_positions_on_position_id", using: :btree

  create_table "person_areas", force: true do |t|
    t.integer  "person_id",                  null: false
    t.integer  "area_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "manages",    default: false, null: false
  end

  add_index "person_areas", ["area_id", "person_id"], name: "index_person_areas_on_area_id_and_person_id", using: :btree
  add_index "person_areas", ["area_id"], name: "index_person_areas_on_area_id", using: :btree
  add_index "person_areas", ["person_id"], name: "index_person_areas_on_person_id", using: :btree

  create_table "poll_question_choices", force: true do |t|
    t.integer  "poll_question_id", null: false
    t.string   "name",             null: false
    t.text     "help_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poll_question_choices", ["poll_question_id"], name: "index_poll_question_choices_on_poll_question_id", using: :btree

  create_table "poll_questions", force: true do |t|
    t.string   "question",                  null: false
    t.text     "help_text"
    t.datetime "start_time",                null: false
    t.datetime "end_time"
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: true do |t|
    t.string   "name"
    t.boolean  "leadership"
    t.boolean  "all_field_visibility"
    t.boolean  "all_corporate_visibility"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "field"
    t.boolean  "hq"
  end

  add_index "positions", ["department_id"], name: "index_positions_on_department_id", using: :btree

  create_table "profile_educations", force: true do |t|
    t.integer  "profile_id",           null: false
    t.string   "school",               null: false
    t.integer  "start_year",           null: false
    t.integer  "end_year",             null: false
    t.string   "degree",               null: false
    t.string   "field_of_study",       null: false
    t.text     "activities_societies"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_educations", ["profile_id"], name: "index_profile_educations_on_profile_id", using: :btree

  create_table "profile_experiences", force: true do |t|
    t.integer  "profile_id",         null: false
    t.string   "company_name",       null: false
    t.string   "title",              null: false
    t.string   "location",           null: false
    t.date     "started",            null: false
    t.date     "ended"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "currently_employed"
  end

  add_index "profile_experiences", ["profile_id"], name: "index_profile_experiences_on_profile_id", using: :btree

  create_table "profile_skills", force: true do |t|
    t.integer  "profile_id", null: false
    t.string   "skill"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_skills", ["profile_id"], name: "index_profile_skills_on_profile_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "person_id",  null: false
    t.string   "theme_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "interests"
    t.text     "bio"
    t.string   "avatar_uid"
    t.string   "image_uid"
    t.string   "nickname"
    t.datetime "last_seen"
  end

  add_index "profiles", ["person_id"], name: "index_profiles_on_person_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name",       null: false
    t.integer  "client_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["client_id"], name: "index_projects_on_client_id", using: :btree

  create_table "publications", force: true do |t|
    t.integer  "publishable_id",   null: false
    t.string   "publishable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publications", ["publishable_id", "publishable_type"], name: "index_publications_on_publishable_id_and_publishable_type", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "person_id",  null: false
    t.integer  "answer_id"
    t.string   "title",      null: false
    t.text     "content",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["answer_id"], name: "index_questions_on_answer_id", using: :btree
  add_index "questions", ["person_id"], name: "index_questions_on_person_id", using: :btree

  create_table "sales_performance_ranks", force: true do |t|
    t.date     "day",           null: false
    t.integer  "rankable_id",   null: false
    t.string   "rankable_type", null: false
    t.integer  "day_rank"
    t.integer  "week_rank"
    t.integer  "month_rank"
    t.integer  "year_rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sales_performance_ranks", ["rankable_id", "rankable_type"], name: "index_sales_performance_ranks_on_rankable_id_and_rankable_type", using: :btree

  create_table "technology_service_providers", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "text_posts", force: true do |t|
    t.integer  "person_id",  null: false
    t.text     "content",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "text_posts", ["person_id"], name: "index_text_posts_on_person_id", using: :btree

  create_table "themes", force: true do |t|
    t.string   "name",         null: false
    t.string   "display_name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploaded_images", force: true do |t|
    t.string   "image_uid",                 null: false
    t.string   "thumbnail_uid",             null: false
    t.string   "preview_uid",               null: false
    t.string   "large_uid",                 null: false
    t.integer  "person_id",                 null: false
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score",         default: 0, null: false
  end

  add_index "uploaded_images", ["person_id"], name: "index_uploaded_images_on_person_id", using: :btree

  create_table "uploaded_videos", force: true do |t|
    t.string   "url",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id",              null: false
    t.integer  "score",      default: 0, null: false
  end

  add_index "uploaded_videos", ["person_id"], name: "index_uploaded_videos_on_person_id", using: :btree

  create_table "wall_post_comments", force: true do |t|
    t.integer  "wall_post_id", null: false
    t.integer  "person_id",    null: false
    t.text     "comment",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wall_post_comments", ["person_id"], name: "index_wall_post_comments_on_person_id", using: :btree
  add_index "wall_post_comments", ["wall_post_id"], name: "index_wall_post_comments_on_wall_post_id", using: :btree

  create_table "wall_posts", force: true do |t|
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

  create_table "walls", force: true do |t|
    t.integer  "wallable_id",   null: false
    t.string   "wallable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "walls", ["wallable_id", "wallable_type"], name: "index_walls_on_wallable_id_and_wallable_type", using: :btree

end
