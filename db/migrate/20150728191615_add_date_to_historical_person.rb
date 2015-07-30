class AddDateToHistoricalPerson < ActiveRecord::Migration
  def change
    add_column :historical_people, :date, :date, null: false
  end
end