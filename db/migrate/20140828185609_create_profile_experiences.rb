class CreateProfileExperiences < ActiveRecord::Migration
  def change
    create_table :profile_experiences do |t|
      t.integer :profile_id
      t.string :company_name
      t.string :title
      t.string :location
      t.date :started
      t.date :ended
      t.text :description

      t.timestamps
    end
  end
end
