class AddDateToHistoricalClientArea < ActiveRecord::Migration
  def change
    add_column :historical_client_areas, :date, :date, null: false
  end
end
