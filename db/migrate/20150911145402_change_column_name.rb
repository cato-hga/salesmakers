class ChangeColumnName < ActiveRecord::Migration
  def change
    remove_column :vonage_transfers, :to_person
    remove_column :vonage_transfers, :from_person
    add_column :vonage_transfers, :to_person_id, :integer
    add_column :vonage_transfers, :from_person_id, :integer
  end
end
