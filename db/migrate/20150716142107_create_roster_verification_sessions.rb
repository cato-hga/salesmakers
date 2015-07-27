class CreateRosterVerificationSessions < ActiveRecord::Migration
  def change
    create_table :roster_verification_sessions do |t|
      t.integer :creator_id, null: false

      t.timestamps null: false
    end
  end
end
