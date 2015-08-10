class ChangeAncestryOnHistoricalArea < ActiveRecord::Migration
  def change
    change_column :historical_areas, :ancestry, :string, null: true
  end
end
