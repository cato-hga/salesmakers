class AddDateToHistoricalLocationClientArea < ActiveRecord::Migration
  def change
    add_column :historical_location_client_areas, :date, :date, null: false
  end
end
