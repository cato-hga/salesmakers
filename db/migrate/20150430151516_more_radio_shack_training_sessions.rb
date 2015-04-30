class MoreRadioShackTrainingSessions < ActiveRecord::Migration
  def change
    SprintRadioShackTrainingSession.create name: '5/11 Training'
    SprintRadioShackTrainingSession.create name: '5/18 Training'
  end
end
