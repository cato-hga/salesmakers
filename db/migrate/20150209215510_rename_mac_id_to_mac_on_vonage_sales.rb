class RenameMacIdToMacOnVonageSales < ActiveRecord::Migration
  def change
    rename_column :vonage_sales, :mac_id, :mac
  end
end
