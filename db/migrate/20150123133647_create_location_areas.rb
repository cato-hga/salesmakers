class CreateLocationAreas < ActiveRecord::Migration
  def change
    create_table :location_areas do |t|
      t.integer :location_id, null: false
      t.integer :area_id, null: false

      t.timestamps null: false
    end
  end
end
