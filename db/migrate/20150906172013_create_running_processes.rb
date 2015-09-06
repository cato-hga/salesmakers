class CreateRunningProcesses < ActiveRecord::Migration
  def change
    create_table :running_processes do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
