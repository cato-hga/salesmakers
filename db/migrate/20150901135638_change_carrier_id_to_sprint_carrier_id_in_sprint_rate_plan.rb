class ChangeCarrierIdToSprintCarrierIdInSprintRatePlan < ActiveRecord::Migration
  def self.up
    rename_column :sprint_rate_plans, :carrier_id, :sprint_carrier_id
  end

  def self.down
    rename_column :sprint_rate_plans, :sprint_carrier_id, :carrier_id
  end
end
