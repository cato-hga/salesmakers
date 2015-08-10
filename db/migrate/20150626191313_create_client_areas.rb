class CreateClientAreas < ActiveRecord::Migration
  def change
    create_table :client_areas do |t|
      t.string :name, null: false
      t.integer :client_area_type_id, null: false
      t.string :ancestry

      t.timestamps
    end
    add_index :client_areas, :ancestry
  end
end
