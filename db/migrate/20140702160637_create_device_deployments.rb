class CreateDeviceDeployments < ActiveRecord::Migration
  def change
    create_table :device_deployments do |t|
      t.integer :device_id, null: false
      t.integer :person_id, null: false
      t.date :started, null: false
      t.date :ended
      t.string :tracking_number
      t.text :comment

      t.timestamps
    end
  end
end
