class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.references :person, index: true, null: false
      t.string :action, null: false
      t.text :comment
      t.references :trackable, index: true, polymorphic: true, null: false
      t.references :referenceable, index: true, polymorphic: true

      t.timestamps
    end
  end
end
