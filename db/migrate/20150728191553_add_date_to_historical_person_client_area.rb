class AddDateToHistoricalPersonClientArea < ActiveRecord::Migration
  def change
    add_column :historical_person_client_areas, :date, :date, null: false
  end
end
