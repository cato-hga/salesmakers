class AddMissingEmployeesToRosterVerificationSession < ActiveRecord::Migration
  def change
    add_column :roster_verification_sessions, :missing_employees, :string
  end
end
