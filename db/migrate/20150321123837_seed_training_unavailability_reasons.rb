class SeedTrainingUnavailabilityReasons < ActiveRecord::Migration
  def self.up
    TrainingUnavailabilityReason.find_or_create_by name: 'Another Job'
    TrainingUnavailabilityReason.find_or_create_by name: 'Personal Reasons'
    TrainingUnavailabilityReason.find_or_create_by name: 'School'
    TrainingUnavailabilityReason.find_or_create_by name: 'Other'
  end

  def self.down
    TrainingUnavailabilityReason.destroy_all
  end
end
