class AddCustomerAcknowledgementToVonageSale < ActiveRecord::Migration
  def change
    add_column :vonage_sales, :customer_acknowledged, :boolean, default: false, null: false
  end
end
