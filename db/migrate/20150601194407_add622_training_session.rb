class Add622TrainingSession < ActiveRecord::Migration
  def change
    SprintRadioShackTrainingSession.create name: '6/22 Training', start_date: Date.new(2015, 06, 22)
  end
end
