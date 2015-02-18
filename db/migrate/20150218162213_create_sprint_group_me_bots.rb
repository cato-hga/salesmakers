class CreateSprintGroupMeBots < ActiveRecord::Migration
  def change
    create_table :sprint_group_me_bots do |t|
      t.string :group_num, null: false
      t.string :bot_num, null: false
      t.integer :area_id, null: false

      t.timestamps null: false
    end
  end
end
