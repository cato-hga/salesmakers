class CreateSprintCarriers < ActiveRecord::Migration
  def change
    create_table :sprint_carriers do |t|
      t.string :name
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
