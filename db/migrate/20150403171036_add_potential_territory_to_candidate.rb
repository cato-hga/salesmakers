class AddPotentialTerritoryToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :potential_area_id, :integer
  end
end
