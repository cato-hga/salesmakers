class AddSalesExperienceAndSalesExperienceNotesToCandidates < ActiveRecord::Migration
  def change
    add_column :prescreen_answers, :has_sales_experience, :boolean, default: false
    add_column :prescreen_answers, :sales_experience_notes, :text
  end
end
