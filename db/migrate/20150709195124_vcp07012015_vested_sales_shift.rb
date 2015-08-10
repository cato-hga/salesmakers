class VCP07012015VestedSalesShift < ActiveRecord::Migration
  def change
    create_table :vcp07012015_vested_sales_shifts do |t|
      t.integer :vonage_commission_period07012015_id, null: false
      t.integer :shift_id, null: false
      t.integer :person_id, null: false
      t.float :hours, null: false

      t.timestamps null: false
    end
  end
end
