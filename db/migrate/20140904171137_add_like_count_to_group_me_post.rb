class AddLikeCountToGroupMePost < ActiveRecord::Migration
  def change
    add_column :group_me_posts, :like_count, :integer, null: false, default: 0
  end
end
