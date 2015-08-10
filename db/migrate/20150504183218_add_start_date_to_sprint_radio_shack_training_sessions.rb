class AddStartDateToSprintRadioShackTrainingSessions < ActiveRecord::Migration
  def change
    add_column :sprint_radio_shack_training_sessions, :start_date, :date
    (1..14).each do |n|
      session = SprintRadioShackTrainingSession.find n
      next unless session
      start_date = case n
                     when 1
                       Date.new(2015, 03, 30)
                     when 2
                       Date.new(2015, 04, 06)
                     when 3
                       Date.new(2015, 04, 13)
                     when 4
                       Date.new(2015, 04, 13)
                     when 5
                       Date.new(2015, 04, 13)
                     when 6
                       Date.new(2015, 04, 20)
                     when 7
                       Date.new(2015, 04, 20)
                     when 8
                       Date.new(2015, 04, 27)
                     when 9
                       Date.new(2015, 04, 27)
                     when 10
                       Date.new(2015, 04, 20)
                     when 11
                       Date.new(2015, 04, 20)
                     when 12
                       Date.new(2015, 05, 11)
                     when 13
                       Date.new(2015, 05, 18)
                     when 14
                       Date.new(2015, 05, 11)
                   end
      session.update start_date: start_date
    end
    change_column_null :sprint_radio_shack_training_sessions, :start_date, false
  end
end
