class AddCandidateIdToCandidateDrugTest < ActiveRecord::Migration
  def change
    add_column :candidate_drug_tests, :candidate_id, :integer
  end
end
