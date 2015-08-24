class ChangeInterviewAnswerRequirements < ActiveRecord::Migration
  def change
    change_column :interview_answers, :why_in_market, :text, null: true
    change_column :interview_answers, :ideal_position, :text, null: true
    change_column :interview_answers, :what_are_you_not_good_at, :text, null: true
    change_column :interview_answers, :compensation_last_job_one, :text, null: true
    change_column :interview_answers, :compensation_last_job_two, :text, null: true
    change_column :interview_answers, :compensation_last_job_three, :text, null: true
    change_column :interview_answers, :hours_looking_to_work, :text, null: true
    change_column :interview_answers, :last_two_positions, :text, null: true
    add_column :interview_answers, :what_interests_you, :text
    execute "update
            interview_answers
            set what_interests_you = 'Question was not on interview answer list when candidate was interviewed'
            where id > 0"
    change_column_null :interview_answers, :what_interests_you, false
    add_column :interview_answers, :first_thing_you_sold, :text
    execute "update
            interview_answers
            set first_thing_you_sold = 'Question was not on interview answer list when candidate was interviewed'
            where id > 0"
    change_column_null :interview_answers, :first_thing_you_sold, false
    add_column :interview_answers, :first_building_of_working_relationship, :text
    execute "update
            interview_answers
            set first_building_of_working_relationship = 'Question was not on interview answer list when candidate was interviewed'
            where id > 0"
    change_column_null :interview_answers, :first_building_of_working_relationship, false
    add_column :interview_answers, :first_rely_on_teaching, :text
    execute "update
            interview_answers
            set first_rely_on_teaching = 'Question was not on interview answer list when candidate was interviewed'
            where id > 0"
    change_column_null :interview_answers, :first_rely_on_teaching, false
    add_column :interview_answers, :availability_confirm, :boolean, default: false, null: false
  end
end
