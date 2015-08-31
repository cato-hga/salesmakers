class ChangeColumnGiftCardNumberInVonageSalesToString < ActiveRecord::Migration
  def change
    change_column :vonage_sales, :gift_card_number, :string
  end
end
