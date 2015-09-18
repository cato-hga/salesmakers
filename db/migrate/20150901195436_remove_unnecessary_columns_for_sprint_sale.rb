class RemoveUnnecessaryColumnsForSprintSale < ActiveRecord::Migration
  def up
    remove_column :sprint_sales, :carrier_name
    remove_column :sprint_sales, :handset_model_name
    remove_column :sprint_sales, :rate_plan_name
  end

  def down
    add_column :sprint_sales, :carrier_name, :string
    add_column :sprint_sales, :handset_model_name, :string
    add_column :sprint_sales, :rate_plan_name, :string
  end
end
