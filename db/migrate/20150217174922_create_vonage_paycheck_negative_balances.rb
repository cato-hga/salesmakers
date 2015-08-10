class CreateVonagePaycheckNegativeBalances < ActiveRecord::Migration
  def change
    create_table :vonage_paycheck_negative_balances do |t|
      t.integer :person_id, null: false
      t.decimal :balance, null: false
      t.integer :vonage_paycheck_id, null: false

      t.timestamps null: false
    end
  end
end
