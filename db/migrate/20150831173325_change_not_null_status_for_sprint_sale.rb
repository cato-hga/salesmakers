class ChangeNotNullStatusForSprintSale < ActiveRecord::Migration
  def change
    change_column :sprint_sales, :carrier_name, :string, null: true
    change_column :sprint_sales, :top_up_card_purchased, :boolean, null: true
    change_column :sprint_sales, :phone_activated_in_store, :boolean, null: true
  end
end
