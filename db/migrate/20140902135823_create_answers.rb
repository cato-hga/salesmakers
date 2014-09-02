class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :person_id, null: false
      t.integer :question_id, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
