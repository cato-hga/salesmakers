class AddMessageNumToGroupMePost < ActiveRecord::Migration
  def change
    add_column :group_me_posts, :message_num, :string, null: false
  end
end
