class CreateCommunicationLogEntries < ActiveRecord::Migration
  def change
    create_table :communication_log_entries do |t|
      t.references :loggable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
