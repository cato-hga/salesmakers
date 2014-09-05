class CreateTextPosts < ActiveRecord::Migration
  def change
    create_table :text_posts do |t|
      t.integer :person_id, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
