class CreateChangelogEntries < ActiveRecord::Migration
  def change
    create_table :changelog_entries do |t|
      t.integer :department_id
      t.integer :project_id
      t.boolean :all_hq
      t.boolean :all_field
      t.string :heading, null: false
      t.text :description, null: false
      t.datetime :released, null: false

      t.timestamps null: false
    end
  end
end
