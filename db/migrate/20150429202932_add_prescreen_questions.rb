class AddPrescreenQuestions < ActiveRecord::Migration
  def up
    add_column :prescreen_answers, :worked_for_radioshack, :boolean, null: false, default: false
    add_column :prescreen_answers, :former_employment_date_start, :date
    add_column :prescreen_answers, :former_employment_date_end, :date
    add_column :prescreen_answers, :store_number_city_state, :string
  end

  def down
    remove_column :prescreen_answers, :worked_for_radioshack, :boolean
    remove_column :prescreen_answers, :former_employment_date_start, :date
    remove_column :prescreen_answers, :former_employment_date_end, :date
    remove_column :prescreen_answers, :store_number_city_state, :string
  end
end