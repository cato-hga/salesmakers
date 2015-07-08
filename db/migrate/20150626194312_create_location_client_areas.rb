class CreateLocationClientAreas < ActiveRecord::Migration
  def change
    create_table :location_client_areas do |t|
      t.integer :location_id, null: false
      t.integer :client_area_id, null: false

      t.timestamps null: false
    end
  end
end
