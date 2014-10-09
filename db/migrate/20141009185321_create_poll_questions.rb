class CreatePollQuestions < ActiveRecord::Migration
  def change
    create_table :poll_questions do |t|
      t.string :question, null: false
      t.text :help_text
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
