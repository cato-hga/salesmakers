class CreateProfileSkills < ActiveRecord::Migration
  def change
    create_table :profile_skills do |t|
      t.integer :profile_id
      t.string :skill

      t.timestamps
    end
  end
end
