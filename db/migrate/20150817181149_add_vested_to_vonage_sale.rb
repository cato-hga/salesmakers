class AddVestedToVonageSale < ActiveRecord::Migration
  def change
    add_column :vonage_sales, :vested, :boolean
  end
end
