class AddSprintRadioShackTrainingSessionIdToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :sprint_radio_shack_training_session_id, :integer
  end
end
