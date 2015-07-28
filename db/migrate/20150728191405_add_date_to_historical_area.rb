class AddDateToHistoricalArea < ActiveRecord::Migration
  def change
    add_column :historical_areas, :date, :date, null: false
  end
end
