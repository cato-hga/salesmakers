class AddIndexesToVonageAccountStatusChange < ActiveRecord::Migration
  def change
    add_index :vonage_account_status_changes, :mac
    add_index :vonage_account_status_changes, :account_end_date
    add_index :vonage_account_status_changes, :status
    add_index :vonage_account_status_changes, [:mac, :account_end_date]
    add_index :vonage_account_status_changes, [:mac, :account_end_date, :status], name: 'vasc_maeds'
  end
end
