class CreateVCP07012015HPSShifts < ActiveRecord::Migration
  def change
    create_table :vcp07012015_hps_shifts do |t|
      t.integer :vonage_commission_period07012015_id, null: false
      t.integer :shift_id, null: false
      t.integer :person_id, null: false
      t.float :hours, null: false

      t.timestamps null: false
    end
  end
end
