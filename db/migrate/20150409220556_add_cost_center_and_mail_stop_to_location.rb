class AddCostCenterAndMailStopToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :cost_center, :string
    add_column :locations, :mail_stop, :string
  end
end
