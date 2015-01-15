class AddPersonIdToCommunicationLogEntry < ActiveRecord::Migration
  def change
    add_column :communication_log_entries, :person_id, :integer, null: false
  end
end
