class CreateVonageSalePayouts < ActiveRecord::Migration
  def change
    create_table :vonage_sale_payouts do |t|
      t.integer :vonage_sale_id, null: false
      t.integer :person_id, null: false
      t.decimal :payout, null: false
      t.integer :vonage_paycheck_id, null: false

      t.timestamps null: false
    end
  end
end
