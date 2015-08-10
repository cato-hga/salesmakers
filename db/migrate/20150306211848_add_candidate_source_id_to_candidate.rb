class AddCandidateSourceIdToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :candidate_source_id, :integer
  end
end
