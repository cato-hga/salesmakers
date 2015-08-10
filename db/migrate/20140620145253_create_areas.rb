class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name, null: false
      t.integer :area_type_id, null: false
      t.string :ancestry

      t.timestamps
    end
    add_index :areas, :ancestry
  end
end
