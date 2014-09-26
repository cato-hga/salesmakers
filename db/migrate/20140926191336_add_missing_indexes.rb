class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :positions, :department_id
    add_index :permissions_positions, :permission_id
    add_index :permissions_positions, :position_id
    add_index :group_me_groups_group_me_users, :group_me_group_id
    add_index :group_me_groups_group_me_users, :group_me_user_id
    add_index :group_me_users, :person_id
    add_index :people, :position_id
    add_index :people, :connect_user_id
    add_index :people, :supervisor_id
    add_index :blog_posts, :person_id
    add_index :projects, :client_id
    add_index :wall_posts, :wall_id
    add_index :wall_posts, :person_id
    add_index :wall_posts, :publication_id
    add_index :wall_posts, :reposted_by_person_id
    add_index :group_me_groups, :area_id
    add_index :walls, [:wallable_id, :wallable_type]
    add_index :uploaded_videos, :person_id
    add_index :uploaded_images, :person_id
    add_index :profile_skills, :profile_id
    add_index :profile_experiences, :profile_id
    add_index :person_areas, :person_id
    add_index :person_areas, :area_id
    add_index :person_areas, [:area_id, :person_id]
    add_index :profile_educations, :profile_id
    add_index :profiles, :person_id
    add_index :text_posts, :person_id
    add_index :questions, :person_id
    add_index :questions, :answer_id
    add_index :publications, [:publishable_id, :publishable_type]
    add_index :area_types, :project_id
    add_index :permissions, :permission_group_id
    add_index :areas, :area_type_id
    add_index :areas, :project_id
    add_index :media, [:mediable_id, :mediable_type]
    add_index :answer_upvotes, :answer_id
    add_index :answer_upvotes, :person_id
    add_index :answers, :person_id
    add_index :answers, :question_id
    add_index :lines, :technology_service_provider_id
    add_index :likes, :person_id
    add_index :likes, :wall_post_id
    add_index :group_me_posts, :group_me_user_id
    add_index :group_me_posts, :group_me_group_id
    add_index :group_me_posts, :person_id
    add_index :employments, :person_id
    add_index :device_models, :device_manufacturer_id
    add_index :device_deployments, :device_id
    add_index :device_deployments, :person_id
    add_index :devices, :device_model_id
    add_index :devices, :line_id
    add_index :devices, :person_id
    add_index :wall_post_comments, :wall_post_id
    add_index :wall_post_comments, :person_id
  end
end