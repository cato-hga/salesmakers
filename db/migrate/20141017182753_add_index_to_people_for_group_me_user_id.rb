class AddIndexToPeopleForGroupMeUserId < ActiveRecord::Migration
  def change
    add_index :people, :group_me_user_id
  end
end
