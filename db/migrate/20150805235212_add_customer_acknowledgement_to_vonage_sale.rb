class AddCustomerAcknowledgementToVonageSale < ActiveRecord::Migration
  def change
    add_column :vonage_sales, :person_acknowledged, :boolean
  end
end
