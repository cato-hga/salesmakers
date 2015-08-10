class SeedDirecTVInstallTimeSlots < ActiveRecord::Migration
  def self.up
    DirecTVInstallTimeSlot.destroy_all
    slots = ['8a-12pm', '12pm-4pm', '4pm-8pm', 'Other']
    for slot in slots do
      DirecTVInstallTimeSlot.create name: slot
    end
  end

  def self.down
    DirecTVInstallTimeSlot.destroy_all
  end
end
