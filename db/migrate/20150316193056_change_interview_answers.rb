class ChangeInterviewAnswers < ActiveRecord::Migration
  def change
    add_column :interview_answers, :willingness_characteristic, :text, null: false
    add_column :interview_answers, :personality_characteristic, :text, null: false
    add_column :interview_answers, :self_motivated_characteristic, :text, null: false
  end
end
