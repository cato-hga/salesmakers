class CreateVonageAccountStatusChanges < ActiveRecord::Migration
  def change
    create_table :vonage_account_status_changes do |t|
      t.string :mac, null: false
      t.date :account_start_date, null: false
      t.date :account_end_date
      t.integer :status, null: false
      t.string :termination_reason

      t.timestamps null: false
    end
  end
end
