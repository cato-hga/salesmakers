class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.integer :person_id, null: false
      t.text :excerpt, null: false
      t.text :content, null: false
      t.string :title, null: false
      t.integer :score, null: false, default: 0

      t.timestamps
    end
  end
end
