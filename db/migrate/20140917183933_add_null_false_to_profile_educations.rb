class AddNullFalseToProfileEducations < ActiveRecord::Migration
  def change
    change_column :profile_educations, :school, :string, null: false
    change_column :profile_educations, :degree, :string, null: false
    change_column :profile_educations, :field_of_study, :string, null: false
    change_column :profile_educations, :start_year, :integer, null: false
    change_column :profile_educations, :end_year, :integer, null: false
  end
end
