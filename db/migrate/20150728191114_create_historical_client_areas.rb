class CreateHistoricalClientAreas < ActiveRecord::Migration
  def change
    create_table :historical_client_areas do |t|
      t.string :name, null: false
      t.integer :client_area_type_id, null: false
      t.string :ancestry
      t.integer :project_id, null: false

      t.timestamps null: false
    end
  end
end
