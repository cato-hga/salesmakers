class CreateGroupMeGroups < ActiveRecord::Migration
  def change
    create_table :group_me_groups do |t|
      t.integer :group_num
      t.integer :area_id
      t.string :name
      t.string :avatar_url

      t.timestamps
    end
  end
end
