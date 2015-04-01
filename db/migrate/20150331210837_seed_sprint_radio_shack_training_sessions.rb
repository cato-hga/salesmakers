class SeedSprintRadioShackTrainingSessions < ActiveRecord::Migration
  def self.up
    SprintRadioShackTrainingSession.create name: 'Session 1 - 3/30'
    SprintRadioShackTrainingSession.create name: 'Session 2 - 4/6'
    SprintRadioShackTrainingSession.create name: 'Session 3 - 4/13'
  end

  def self.down
    SprintRadioShackTrainingSession.destroy_all
  end
end
