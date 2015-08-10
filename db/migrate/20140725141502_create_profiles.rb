class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :person_id, null: false
      t.string :theme_name

      t.timestamps
    end
  end
end
