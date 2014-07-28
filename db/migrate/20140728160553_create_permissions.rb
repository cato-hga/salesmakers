class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :key, null: false
      t.string :description, null: false
      t.integer :permission_group_id, null: false

      t.timestamps
    end
  end
end
