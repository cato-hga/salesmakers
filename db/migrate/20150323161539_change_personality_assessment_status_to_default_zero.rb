class ChangePersonalityAssessmentStatusToDefaultZero < ActiveRecord::Migration
  def change
    change_column :candidates, :personality_assessment_status, :integer, null: false, default: 0
  end
end
