class CreatePersonAreas < ActiveRecord::Migration
  def change
    create_table :person_areas do |t|
      t.integer :person_id, null: false
      t.integer :area_id, null: false

      t.timestamps
    end
  end
end
