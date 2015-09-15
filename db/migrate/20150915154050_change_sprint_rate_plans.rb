class ChangeSprintRatePlans < ActiveRecord::Migration
  def up
    carrier = SprintCarrier.find_by name: 'Virgin Mobile0'
    if carrier
      SprintHandset.find_or_create_by sprint_carrier: carrier, name: 'CUSTOM'
    end
  end

  def down
    handset = SprintHandset.find_by name: 'CUSTOM'
    handset.destroy if handset
  end
end
