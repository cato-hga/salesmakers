class CreateSprintHandsets < ActiveRecord::Migration
  def change
    create_table :sprint_handsets do |t|
      t.string :name
      t.integer :carrier_id

      t.timestamps null: false
    end
  end
end
