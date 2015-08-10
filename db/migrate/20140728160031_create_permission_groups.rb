class CreatePermissionGroups < ActiveRecord::Migration
  def change
    create_table :permission_groups do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
