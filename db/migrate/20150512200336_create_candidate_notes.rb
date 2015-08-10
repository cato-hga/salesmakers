class CreateCandidateNotes < ActiveRecord::Migration
  def change
    create_table :candidate_notes do |t|
      t.integer :candidate_id, null: false
      t.integer :person_id, null: false
      t.text :note, null: false

      t.timestamps null: false
    end
  end
end
