class AddPersonalityAssessmentCompletedToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :personality_assessment_completed, :boolean, null: false, default: false
  end
end
