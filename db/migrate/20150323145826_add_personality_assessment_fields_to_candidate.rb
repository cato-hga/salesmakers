class AddPersonalityAssessmentFieldsToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :personality_assessment_status, :integer
    add_column :candidates, :personality_assessment_score, :float
  end
end
