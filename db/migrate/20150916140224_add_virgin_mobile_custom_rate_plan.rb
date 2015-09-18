class AddVirginMobileCustomRatePlan < ActiveRecord::Migration
  def up
    carrier = SprintCarrier.find_by name: 'Virgin Mobile' || return
    SprintRatePlan.find_or_create_by name: 'CUSTOM', sprint_carrier: carrier
  end

  def down
    carrier = SprintCarrier.find_by name: 'Virgin Mobile' || return
    SprintRatePlan.where(sprint_carrier: carrier, name: 'CUSTOM').destroy_all
  end
end
