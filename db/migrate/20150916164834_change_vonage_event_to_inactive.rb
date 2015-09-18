class ChangeVonageEventToInactive < ActiveRecord::Migration
  def up
    project = Project.find_by name: 'Vonage Events'
    return unless project
    project.update active: false
  end

  def down
    project = Project.find_by name: 'Vonage Events'
    return unless project
    project.update active: true
  end
end
