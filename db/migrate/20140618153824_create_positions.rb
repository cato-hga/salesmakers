class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :name, null: false
      t.boolean :leadership, null: false
      t.boolean :all_field_visibility, null: false
      t.boolean :all_corporate_visibility, null: false
      t.integer :department_id, null: false

      t.timestamps
    end
  end
end
