class ChangePrescreenQuestions < ActiveRecord::Migration
  def change
    add_column :prescreen_answers, :worked_for_sprint, :boolean, default: false, null: false
    add_column :prescreen_answers, :high_school_diploma, :boolean, default: false, null: false
    remove_column :prescreen_answers, :part_time_employment
    remove_column :prescreen_answers, :access_to_computer
  end
end
