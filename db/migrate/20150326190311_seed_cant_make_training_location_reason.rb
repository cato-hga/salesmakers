class SeedCantMakeTrainingLocationReason < ActiveRecord::Migration
  def change
    TrainingUnavailabilityReason.create name: "Can't Make Training Location"
  end
end
