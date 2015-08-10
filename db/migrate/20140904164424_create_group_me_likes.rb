class CreateGroupMeLikes < ActiveRecord::Migration
  def change
    create_table :group_me_likes do |t|
      t.integer :group_me_user_id, null: false
      t.integer :group_me_post_id, null: false
      t.timestamps
    end

    add_index :group_me_likes, :group_me_user_id
    add_index :group_me_likes, :group_me_post_id
    add_index :group_me_likes, [:group_me_user_id, :group_me_post_id]
    add_index :group_me_likes, [:group_me_post_id, :group_me_user_id]
  end
end
