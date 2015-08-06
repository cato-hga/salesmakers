class RenameColumnCustomerAcknowledgedToPersonAcknowledgedInVonageSales < ActiveRecord::Migration
  def change
    rename_column :vonage_sales, :customer_acknowledged, :person_acknowledged
  end
end
