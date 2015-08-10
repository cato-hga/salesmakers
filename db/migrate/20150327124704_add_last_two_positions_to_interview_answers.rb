class AddLastTwoPositionsToInterviewAnswers < ActiveRecord::Migration
  def up
    add_column :interview_answers, :last_two_positions, :text
    execute "update
            interview_answers
            set last_two_positions = 'Question was not on interview answer list when candidate was interviewed'
            where id > 0"
    change_column_null :interview_answers, :last_two_positions, false
  end

  def down
    remove_column :interview_answers, :last_two_positions, :text
  end
end
