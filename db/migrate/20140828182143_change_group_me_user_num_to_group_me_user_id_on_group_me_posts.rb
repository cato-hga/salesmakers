class ChangeGroupMeUserNumToGroupMeUserIdOnGroupMePosts < ActiveRecord::Migration
  def change
    remove_column :group_me_posts, :group_me_user_num
    add_column :group_me_posts, :group_me_user_id, :integer, null: false
  end
end
