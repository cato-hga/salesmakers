class CreateWorkmarketLocations < ActiveRecord::Migration
  def change
    create_table :workmarket_locations do |t|
      t.string :workmarket_location_num, null: false
      t.string :name, null: false
      t.string :location_number

      t.timestamps null: false
    end
  end
end
