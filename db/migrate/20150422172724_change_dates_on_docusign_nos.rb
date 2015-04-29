class ChangeDatesOnDocusignNos < ActiveRecord::Migration
  def change
    change_column :docusign_noses, :last_day_worked, :datetime
    change_column :docusign_noses, :termination_date, :datetime
  end
end
