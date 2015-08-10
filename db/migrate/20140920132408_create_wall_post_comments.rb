class CreateWallPostComments < ActiveRecord::Migration
  def change
    create_table :wall_post_comments do |t|
      t.integer :wall_post_id, null: false
      t.integer :person_id, null: false
      t.text :comment, null: false

      t.timestamps
    end
  end
end
