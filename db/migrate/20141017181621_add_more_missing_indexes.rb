class AddMoreMissingIndexes < ActiveRecord::Migration
  def change
    add_index :day_sales_counts, [:saleable_id, :saleable_type]
    add_index :link_posts, :person_id
    add_index :people_poll_question_choices, :person_id, name: 'people_poll_choices_person'
    add_index :people_poll_question_choices, [:poll_question_choice_id, :person_id], name: 'people_poll_choices_person_choice'
    add_index :poll_question_choices, :poll_question_id
    add_index :sales_performance_ranks, [:rankable_id, :rankable_type]
  end
end
