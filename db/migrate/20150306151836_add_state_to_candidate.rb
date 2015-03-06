class AddStateToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :state, :string, limit: 2
  end
end
