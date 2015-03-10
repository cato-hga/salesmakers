class CreateInterviewAnswers < ActiveRecord::Migration
  def change
    create_table :interview_answers do |t|
      t.text :work_history, null: false
      t.text :why_in_market, null: false
      t.text :ideal_position, null: false
      t.text :what_are_you_good_at, null: false
      t.text :what_are_you_not_good_at, null: false
      t.string :compensation_last_job_one, null: false
      t.string :compensation_last_job_two
      t.string :compensation_last_job_three
      t.string :compensation_seeking, null: false
      t.string :hours_looking_to_work, null: false

      t.timestamps null: false
    end
  end
end
