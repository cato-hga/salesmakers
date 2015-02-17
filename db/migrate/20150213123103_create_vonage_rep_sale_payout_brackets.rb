class CreateVonageRepSalePayoutBrackets < ActiveRecord::Migration
  def change
    create_table :vonage_rep_sale_payout_brackets do |t|
      t.decimal :per_sale, null: false
      t.integer :area_id, null: false
      t.integer :sales_minimum, null: false
      t.integer :sales_maximum, null: false

      t.timestamps null: false
    end
  end
end
