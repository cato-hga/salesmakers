class RemoveTrainingUnavailabilityReasonIdFromSprint < ActiveRecord::Migration
  def change
    remove_column :sprint_pre_training_welcome_calls, :training_unavailability_reason_id
  end
end
