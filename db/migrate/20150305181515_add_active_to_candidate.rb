class AddActiveToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :active, :boolean, null: false, default: true
  end
end
