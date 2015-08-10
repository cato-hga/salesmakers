class CreateHistoricalPersonAreas < ActiveRecord::Migration
  def change
    create_table :historical_person_areas do |t|
      t.integer :historical_person_id, null: false
      t.integer :historical_area_id, null: false
      t.boolean :manages, null: false, default: false

      t.timestamps null: false
    end
  end
end
