class AddPersonalityAssessmentUrlToArea < ActiveRecord::Migration
  def change
    add_column :areas, :personality_assessment_url, :string
  end
end
