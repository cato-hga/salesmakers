class RemoveProjectIdFromCandidates < ActiveRecord::Migration
  def change
    remove_column :candidates, :project_id, :integer
  end
end
