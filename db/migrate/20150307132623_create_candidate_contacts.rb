class CreateCandidateContacts < ActiveRecord::Migration
  def change
    create_table :candidate_contacts do |t|
      t.integer :contact_method, null: false
      t.boolean :inbound, null: false, default: false
      t.integer :person_id, null: false
      t.integer :candidate_id, null: false
      t.text :notes, null: false

      t.timestamps null: false
    end
  end
end
