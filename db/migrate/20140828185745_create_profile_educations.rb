class CreateProfileEducations < ActiveRecord::Migration
  def change
    create_table :profile_educations do |t|
      t.integer :profile_id
      t.string :school
      t.integer :start_year
      t.integer :end_year
      t.string :degree
      t.string :field_of_study
      t.text :activities_societies
      t.text :description

      t.timestamps
    end
  end
end
