class CreateDirecTVInstallAppointments < ActiveRecord::Migration
  def change
    create_table :directv_install_appointments do |t|
      t.integer :directv_install_time_slot_id, null: false
      t.integer :directv_sale_id, null: false
      t.date :install_date, null: false
      t.timestamps null: false
    end
  end
end
