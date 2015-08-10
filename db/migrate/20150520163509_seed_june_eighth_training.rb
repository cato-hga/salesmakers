class SeedJuneEighthTraining < ActiveRecord::Migration
  def change
    SprintRadioShackTrainingSession.create name: '6/8 Training',
                                           start_date: Date.new(2015, 6, 8)
  end
end
