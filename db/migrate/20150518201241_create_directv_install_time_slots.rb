class CreateDirecTVInstallTimeSlots < ActiveRecord::Migration
  def change
    create_table :directv_install_time_slots do |t|
      t.boolean :active, default: true, null: false
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
