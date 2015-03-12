class AddResoldToVonageSales < ActiveRecord::Migration
  def change
    add_column :vonage_sales, :resold, :boolean, null: false, default: false
  end
end
