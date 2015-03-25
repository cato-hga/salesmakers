class CreateSprintRadioShackTrainingLocations < ActiveRecord::Migration
  def change
    create_table :sprint_radio_shack_training_locations do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :room, null: false
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end