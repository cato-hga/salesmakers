class AddUpdatePositionFromConnectToPerson < ActiveRecord::Migration
  def change
    add_column :people, :update_position_from_connect, :boolean, null: false, default: true
  end
end
