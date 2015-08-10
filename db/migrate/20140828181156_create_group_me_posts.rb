class CreateGroupMePosts < ActiveRecord::Migration
  def change
    create_table :group_me_posts do |t|
      t.integer :group_me_group_id, null: false
      t.datetime :posted_at, null: false
      t.string :group_me_user_num, null: false
      t.text :json, null: false

      t.timestamps
    end
  end
end
