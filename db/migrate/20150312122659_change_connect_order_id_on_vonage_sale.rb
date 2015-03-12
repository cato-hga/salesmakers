class ChangeConnectOrderIdOnVonageSale < ActiveRecord::Migration
  def change
    rename_column :vonage_sales, :connect_order_id, :connect_order_uuid
  end
end
