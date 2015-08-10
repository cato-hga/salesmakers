class CreateA2LocationSchedule < ActiveRecord::Migration
  def change
    RadioShackLocationSchedule.create name: 'A2PT1',
                                      active: true,
                                      tuesday: 4,
                                      wednesday: 4,
                                      thursday: 4,
                                      friday: 4,
                                      saturday: 4
    RadioShackLocationSchedule.create name: 'A2PT2',
                                      active: true,
                                      monday: 4,
                                      tuesday: 8,
                                      friday: 4,
                                      saturday: 4
    a1 = RadioShackLocationSchedule.find_by name: 'A1'
    a1.update name: 'A1PT1'
    RadioShackLocationSchedule.create name: 'A1PT2',
                                      active: true,
                                      monday: 4,
                                      tuesday: 8,
                                      wednesday: 4,
                                      thursday: 4
  end
end
