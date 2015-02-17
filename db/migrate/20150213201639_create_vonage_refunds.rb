class CreateVonageRefunds < ActiveRecord::Migration
  def change
    create_table :vonage_refunds do |t|
      t.integer :vonage_sale_id, null: false
      t.integer :vonage_account_status_change_id, null: false
      t.date :refund_date, null: false
      t.integer :person_id, null: false

      t.timestamps null: false
    end
  end
end
