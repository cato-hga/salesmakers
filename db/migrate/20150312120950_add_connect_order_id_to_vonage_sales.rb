class AddConnectOrderIdToVonageSales < ActiveRecord::Migration
  def change
    add_column :vonage_sales, :connect_order_id, :string
  end
end
