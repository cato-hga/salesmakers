class AddActivationsAndNewAccountsToDaySalesCounts < ActiveRecord::Migration
  def change
    add_column :day_sales_counts, :activations, :integer, null: false, default: 0
    add_column :day_sales_counts, :new_accounts, :integer, null: false, default: 0
  end
end
