class AddProjectIdToCandidate < ActiveRecord::Migration
  def up
    add_column :candidates, :project_id, :integer
    ActiveRecord::Base.record_timestamps = false
    begin
      project = Project.find_by name: 'Sprint Postpaid'
      return unless project
      Candidate.update_all project_id: project.id
    ensure
      ActiveRecord::Base.record_timestamps = true  # don't forget to enable it again!
    end
  end

  def down
    begin
      Candidate.update_all project_id: nil
    ensure
      ActiveRecord::Base.record_timestamps = true  # don't forget to enable it again!
    end
    remove_column :candidates, :project_id
  end
end
