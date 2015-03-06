class AddProjectIdToDocusignTemplate < ActiveRecord::Migration
  def change
    add_column :docusign_templates, :project_id, :integer, null: false
  end
end
