class CreateCandidateReconciliations < ActiveRecord::Migration
  def change
    create_table :candidate_reconciliations do |t|
      t.integer :candidate_id, null: false
      t.integer :status, null: false, default: 0

      t.timestamps null: false
    end
  end
end
