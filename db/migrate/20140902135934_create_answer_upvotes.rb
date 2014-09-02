class CreateAnswerUpvotes < ActiveRecord::Migration
  def change
    create_table :answer_upvotes do |t|
      t.integer :answer_id, null: false
      t.integer :person_id, null: false

      t.timestamps
    end
  end
end
