class AddMacIndexToVonageSale < ActiveRecord::Migration
  def change
    add_index :vonage_sales, :mac
  end
end
