class CreateRosterVerifications < ActiveRecord::Migration
  def change
    create_table :roster_verifications do |t|
      t.integer :creator_id, null: false
      t.integer :person_id, null: false
      t.integer :status, null: false, default: 0
      t.date :last_shift_date
      t.integer :location_id
      t.string :envelope_guid
      t.integer :roster_verification_session_id, null: false

      t.timestamps null: false
    end
  end
end
