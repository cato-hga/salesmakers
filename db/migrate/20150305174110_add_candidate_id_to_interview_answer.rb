class AddCandidateIdToInterviewAnswer < ActiveRecord::Migration
  def change
    add_column :interview_answers, :candidate_id, :integer
  end
end
