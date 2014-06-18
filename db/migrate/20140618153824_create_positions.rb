class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :name
      t.boolean :leadership
      t.boolean :all_field_visibility
      t.boolean :all_corporate_visibility
      t.integer :department_id

      t.timestamps
    end
  end
end
