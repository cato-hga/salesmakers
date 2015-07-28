class CreateHistoricalPersonClientAreas < ActiveRecord::Migration
  def change
    create_table :historical_person_client_areas do |t|
      t.integer :historical_person_id, null: false
      t.integer :historical_client_area_id, null: false

      t.timestamps null: false
    end
  end
end
