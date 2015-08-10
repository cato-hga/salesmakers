class RemoveNullFalseFromDocusignNosAttributes < ActiveRecord::Migration
  def change
    change_column_null :docusign_noses, :employment_end_reason_id, true
    change_column_null :docusign_noses, :last_day_worked, true
    change_column_null :docusign_noses, :termination_date, true
  end
end
