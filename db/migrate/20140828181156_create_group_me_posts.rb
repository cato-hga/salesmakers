class CreateGroupMePosts < ActiveRecord::Migration
  def change
    create_table :group_me_posts do |t|
      t.integer :group_me_group_id
      t.datetime :posted_at
      t.string :group_me_user_num
      t.text :json

      t.timestamps
    end
  end
end
