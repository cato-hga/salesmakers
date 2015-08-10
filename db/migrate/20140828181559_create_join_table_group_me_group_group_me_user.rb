class CreateJoinTableGroupMeGroupGroupMeUser < ActiveRecord::Migration
  def change
    create_join_table :group_me_groups, :group_me_users, table_name: :group_me_groups_group_me_users do |t|
      t.index [:group_me_group_id, :group_me_user_id], name: 'gm_groups_and_users'
      t.index [:group_me_user_id, :group_me_group_id], name: 'gm_users_and_groups'
    end
  end
end
