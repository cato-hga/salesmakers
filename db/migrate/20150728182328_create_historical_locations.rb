class CreateHistoricalLocations < ActiveRecord::Migration
  def change
    create_table :historical_locations do |t|
      t.string :display_name
      t.string :store_number, null: false
      t.string :street_1
      t.string :street_2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip
      t.integer :channel_id, null: false
      t.float :latitude
      t.float :longitude
      t.integer :sprint_radio_shack_training_location_id
      t.string :cost_center
      t.string :mail_stop

      t.timestamps null: false
    end
  end
end
