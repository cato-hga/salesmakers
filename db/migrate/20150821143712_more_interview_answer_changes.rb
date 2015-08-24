class MoreInterviewAnswerChanges < ActiveRecord::Migration
  def change
    change_column :interview_answers, :what_are_you_good_at, :text, null: true
  end
end
