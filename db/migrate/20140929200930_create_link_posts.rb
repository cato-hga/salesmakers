class CreateLinkPosts < ActiveRecord::Migration
  def change
    create_table :link_posts do |t|
      t.string :image_uid, null: false
      t.string :thumbnail_uid, null: false
      t.string :preview_uid, null: false
      t.string :large_uid, null: false
      t.integer :person_id, null: false
      t.string :title
      t.integer :score, default: 0, null: false

      t.timestamps
    end
  end
end
