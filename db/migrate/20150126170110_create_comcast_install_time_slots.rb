class CreateComcastInstallTimeSlots < ActiveRecord::Migration
  def change
    create_table :comcast_install_time_slots do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: true

      t.timestamps null: false
    end
  end
end
