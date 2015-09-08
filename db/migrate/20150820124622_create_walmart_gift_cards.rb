class CreateWalmartGiftCards < ActiveRecord::Migration
  def change
    create_table :walmart_gift_cards do |t|
      t.boolean :used, null: false, default: false
      t.string :card_number, null: false
      t.string :link, null: false
      t.string :challenge_code, null: false
      t.string :unique_code
      t.string :pin, null: false
      t.float :balance, null: false, default: 0.0
      t.date :purchase_date
      t.float :purchase_amount
      t.string :store_number
      t.integer :vonage_sale_id
      t.boolean :overridden, null: false, default: false

      t.timestamps null: false
    end
  end
end
