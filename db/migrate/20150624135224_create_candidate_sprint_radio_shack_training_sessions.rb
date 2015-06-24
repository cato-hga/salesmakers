class CreateCandidateSprintRadioShackTrainingSessions < ActiveRecord::Migration
  def change
    create_table :candidate_sprint_radio_shack_training_sessions do |t|
      t.integer :candidate_id, null: false
      t.integer :sprint_radio_shack_training_session_id, null: false
      t.integer :sprint_roster_status, null: false, default: 0

      t.timestamps null: false
    end
  end
end
