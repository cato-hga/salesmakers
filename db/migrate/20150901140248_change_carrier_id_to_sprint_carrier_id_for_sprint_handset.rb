class ChangeCarrierIdToSprintCarrierIdForSprintHandset < ActiveRecord::Migration
  def self.up
    rename_column :sprint_handsets, :carrier_id, :sprint_carrier_id
  end

  def self.down
    rename_column :sprint_handsets,:sprint_carrier_id, :carrier_id
  end
end
