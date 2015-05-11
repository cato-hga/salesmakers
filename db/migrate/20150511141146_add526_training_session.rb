class Add526TrainingSession < ActiveRecord::Migration
  def change
    SprintRadioShackTrainingSession.create name: '5/26 Training', start_date: Date.new(2015, 05, 26)
  end
end
