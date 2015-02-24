class AddChangelogEntryIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :changelog_entry_id, :integer
  end
end
