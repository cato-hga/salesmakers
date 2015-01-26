class CreateComcastInstallAppointments < ActiveRecord::Migration
  def change
    create_table :comcast_install_appointments do |t|
      t.date :install_date, null: false
      t.integer :comcast_install_time_slot_id, null: false
      t.integer :comcast_sale_id, null: false

      t.timestamps null: false
    end
  end
end
