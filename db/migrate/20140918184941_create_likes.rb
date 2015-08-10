class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :person_id, null: false
      t.integer :wall_post_id, null: false

      t.timestamps
    end
  end
end
