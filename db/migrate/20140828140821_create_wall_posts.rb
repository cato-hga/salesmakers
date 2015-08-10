class CreateWallPosts < ActiveRecord::Migration
  def change
    create_table :wall_posts do |t|
      t.integer :publication_id, null: false
      t.integer :wall_id, null: false
      t.integer :person_id, null: false

      t.timestamps
    end
  end
end
