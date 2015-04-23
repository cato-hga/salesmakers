class AddTrainingSessionStatusToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :training_session_status, :integer, null: false, default: 0
  end
end
