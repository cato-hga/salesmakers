class CreateProcessLogs < ActiveRecord::Migration
  def change
    create_table :process_logs do |t|
      t.string :process_class, null: false
      t.integer :records_processed, null: false, default: 0
      t.text :notes

      t.timestamps null: false
    end
  end
end
