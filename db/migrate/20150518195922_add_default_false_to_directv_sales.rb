class AddDefaultFalseToDirecTVSales < ActiveRecord::Migration
  def change
    change_column :directv_sales, :customer_acknowledged, :boolean, null: false, default: false
  end
end
