class CreatePersonClientAreas < ActiveRecord::Migration
  def change
    create_table :person_client_areas do |t|
      t.integer :person_id, null: false
      t.integer :client_area_id, null: false

      t.timestamps
    end
  end
end
