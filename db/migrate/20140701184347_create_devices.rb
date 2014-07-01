class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :identifier, null: false
      t.string :serial, null: false
      t.integer :device_model_id, null: false
      t.integer :line_id
      t.integer :person_id

      t.timestamps
    end
  end
end
