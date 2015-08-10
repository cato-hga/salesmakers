class AddPassedAssetHoursRequirementToPeople < ActiveRecord::Migration
  def change
    add_column :people, :passed_asset_hours_requirement, :boolean, null: false, default: false
  end
end
