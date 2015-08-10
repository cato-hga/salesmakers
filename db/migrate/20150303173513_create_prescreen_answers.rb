class CreatePrescreenAnswers < ActiveRecord::Migration
  def change
    create_table :prescreen_answers do |t|
      t.integer :candidate_id, null: false
      t.boolean :worked_for_salesmakers, null: false
      t.boolean :of_age_to_work, null: false
      t.boolean :eligible_smart_phone, null: false
      t.boolean :can_work_weekends, null: false
      t.boolean :reliable_transportation, null: false
      t.boolean :access_to_computer, null: false
      t.boolean :part_time_employment, null: false
      t.boolean :ok_to_screen, null: false

      t.timestamps null: false
    end
  end
end
