class AddDateToHistoricalLocation < ActiveRecord::Migration
  def change
    add_column :historical_locations, :date, :date, null: false
  end
end
