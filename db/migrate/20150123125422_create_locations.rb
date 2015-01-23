class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :display_name
      t.string :store_number, null: false
      t.string :street_1
      t.string :street_2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip
      t.integer :channel_id, null: false

      t.timestamps null: false
    end
  end
end
