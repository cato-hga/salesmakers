class AddNullFalseToProfileIdOnProfileExperienceProfileSkillsProfileEducation < ActiveRecord::Migration
  def change
    change_column :profile_experiences, :profile_id, :integer, null: false
    change_column :profile_skills, :profile_id, :integer, null: false
    change_column :profile_educations, :profile_id, :integer, null: false
  end
end
