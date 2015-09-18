class AddCarrierRatePlanAndHandsetIdsToSprintSale < ActiveRecord::Migration
  def change
    add_column :sprint_sales, :sprint_carrier_id, :integer
    add_column :sprint_sales, :sprint_handset_id, :integer
    add_column :sprint_sales, :sprint_rate_plan_id, :integer
  end
end
