class CreateDocusignTemplates < ActiveRecord::Migration
  def change
    create_table :docusign_templates do |t|
      t.string :template_guid, null: false
      t.string :state, null: false, limit: 2
      t.integer :document_type, null: false, default: 0

      t.timestamps null: false
    end
  end
end
