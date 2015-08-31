class AddGiftCardNumberToVonageSale < ActiveRecord::Migration
  def change
    add_column :vonage_sales, :gift_card_number, :integer
  end
end
