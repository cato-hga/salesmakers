class CreateJoinTablePersonPollQuestionChoice < ActiveRecord::Migration
  def change
    create_join_table :people, :poll_question_choices do |t|
      t.index [:person_id, :poll_question_choice_id], name: 'ppqc_person_choice'
      t.index [:poll_question_choice_id, :person_id], name: 'ppqc_choice_person'
    end
  end
end
