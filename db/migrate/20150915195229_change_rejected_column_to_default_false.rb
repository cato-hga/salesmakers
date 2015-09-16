class ChangeRejectedColumnToDefaultFalse < ActiveRecord::Migration
  def change
    change_column :vonage_transfers, :rejected, :boolean, default: false, null:false
  end
end
