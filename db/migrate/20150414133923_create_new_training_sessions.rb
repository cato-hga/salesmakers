class CreateNewTrainingSessions < ActiveRecord::Migration
  def change
    training_a = SprintRadioShackTrainingSession.find_by name: '4/20 - In Training - Virtual'
    training_a.update name: '4/20 - In Training - Virtual A'
    SprintRadioShackTrainingSession.create name: '4/20 - In Training - Virtual B'
    SprintRadioShackTrainingSession.create name: '4/20 - In Training - Virtual C'


  end
end
