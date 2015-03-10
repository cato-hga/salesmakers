class AddDefaultFalseToPrescreenAnswersTable < ActiveRecord::Migration
  def change
    change_column :prescreen_answers, :worked_for_salesmakers, :boolean, default: false, null: false
    change_column :prescreen_answers, :of_age_to_work, :boolean, default: false, null: false
    change_column :prescreen_answers, :eligible_smart_phone, :boolean, default: false, null: false
    change_column :prescreen_answers, :can_work_weekends, :boolean, default: false, null: false
    change_column :prescreen_answers, :reliable_transportation, :boolean, default: false, null: false
    change_column :prescreen_answers, :access_to_computer, :boolean, default: false, null: false
    change_column :prescreen_answers, :part_time_employment, :boolean, default: false, null: false
    change_column :prescreen_answers, :ok_to_screen, :boolean, default: false, null: false
  end
end
