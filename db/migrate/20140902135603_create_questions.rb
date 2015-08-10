class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :person_id, null: false
      t.integer :answer_id
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
