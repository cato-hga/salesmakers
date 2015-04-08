class CreateUnmatchCandidates < ActiveRecord::Migration
  def change
    create_table :unmatched_candidates do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :email, null: false
      t.float :score, null: false

      t.timestamps null: false
    end
  end
end
