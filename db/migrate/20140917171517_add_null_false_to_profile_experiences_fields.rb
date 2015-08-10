class AddNullFalseToProfileExperiencesFields < ActiveRecord::Migration
  def change
    change_column :profile_experiences, :company_name, :string, null: false
    change_column :profile_experiences, :title, :string, null: false
    change_column :profile_experiences, :started, :date, null: false
    change_column :profile_experiences, :location, :string, null: false
    add_column :profile_experiences, :currently_employed, :boolean
  end
end
