class AddIssueToRosterVerification < ActiveRecord::Migration
  def change
    add_column :roster_verifications, :issue, :string
  end
end
