class AddMessageNumIndexToGroupMePost < ActiveRecord::Migration
  def change
    add_index :group_me_posts, :message_num
  end
end
