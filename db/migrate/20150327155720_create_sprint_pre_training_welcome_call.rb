class CreateSprintPreTrainingWelcomeCall < ActiveRecord::Migration
  def change
    create_table :sprint_pre_training_welcome_calls do |t|
      t.boolean :still_able_to_attend, null: false, default: false
      t.integer :training_unavailability_reason_id
      t.text :comment
      t.boolean :group_me_reviewed, null: false, default: false
      t.boolean :group_me_confirmed, null: false, default: false
      t.boolean :cloud_reviewed, null: false, default: false
      t.boolean :cloud_confirmed, null: false, default: false
      t.boolean :epay_reviewed, null: false, default: false
      t.boolean :epay_confirmed, null: false, default: false
      t.boolean :completed, null: false, default: false
      t.integer :candidate_id, null: false
    end
  end
end
