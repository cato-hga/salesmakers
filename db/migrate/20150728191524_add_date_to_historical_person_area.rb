class AddDateToHistoricalPersonArea < ActiveRecord::Migration
  def change
    add_column :historical_person_areas, :date, :date, null: false
  end
end
