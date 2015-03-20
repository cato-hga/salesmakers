class AddCandidateIdToTrainingAvailability < ActiveRecord::Migration
  def change
    add_column :training_availabilities, :candidate_id, :integer, null: false
  end
end
