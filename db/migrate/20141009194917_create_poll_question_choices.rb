class CreatePollQuestionChoices < ActiveRecord::Migration
  def change
    create_table :poll_question_choices do |t|
      t.integer :poll_question_id, null: false
      t.string :name, null: false
      t.text :help_text

      t.timestamps
    end
  end
end
