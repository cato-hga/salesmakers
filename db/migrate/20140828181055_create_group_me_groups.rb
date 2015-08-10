class CreateGroupMeGroups < ActiveRecord::Migration
  def change
    create_table :group_me_groups do |t|
      t.integer :group_num, null: false
      t.integer :area_id
      t.string :name, null: false
      t.string :avatar_url

      t.timestamps
    end
  end
end
