class SeedRadioShackLocationSchedules < ActiveRecord::Migration
  def change
    RadioShackLocationSchedule.create name: 'A1', active: true, tuesday: 4, wednesday: 8, friday: 4, saturday: 4
    RadioShackLocationSchedule.create name: 'B1', active: true, tuesday: 8, wednesday: 8
    RadioShackLocationSchedule.create name: 'B2', active: true, tuesday: 8, thursday: 4, friday: 4, saturday: 4.5
    RadioShackLocationSchedule.create name: 'B3', active: true, monday: 4, tuesday: 4, wednesday: 4, thursday: 4, friday: 4
  end
end
