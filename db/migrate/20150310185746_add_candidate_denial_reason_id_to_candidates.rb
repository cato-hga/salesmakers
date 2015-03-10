class AddCandidateDenialReasonIdToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :candidate_denial_reason_id, :integer
  end
end

