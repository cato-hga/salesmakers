class SeedComcastInstallTimeSlots < ActiveRecord::Migration
  def self.up
    ComcastInstallTimeSlot.destroy_all
    slots = ['8a-10a', '10a-12p', '1p-3p', '3p-5p', 'Other']
    for slot in slots do
      ComcastInstallTimeSlot.create name: slot
    end
  end

  def self.down
    ComcastInstallTimeSlot.destroy_all
  end
end
