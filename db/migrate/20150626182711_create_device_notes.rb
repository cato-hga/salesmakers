class CreateDeviceNotes < ActiveRecord::Migration
  def change
    create_table :device_notes do |t|
      t.integer :device_id
      t.text :note
      t.integer :person_id

      t.timestamps null: false
    end
  end
end
