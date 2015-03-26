class AddRevenueSharingFieldsToVonageSalePayout < ActiveRecord::Migration
  def change
    add_column :vonage_sale_payouts, :day_62, :boolean, null: false, default: false
    add_column :vonage_sale_payouts, :day_92, :boolean, null: false, default: false
    add_column :vonage_sale_payouts, :day_122, :boolean, null: false, default: false
    add_column :vonage_sale_payouts, :day_152, :boolean, null: false, default: false
  end
end
