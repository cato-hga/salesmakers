class CreateVCP07012015HPSSales < ActiveRecord::Migration
  def change
    create_table :vcp07012015_hps_sales do |t|
      t.integer :vonage_commission_period07012015_id, null: false
      t.integer :vonage_sale_id, null: false
      t.integer :person_id, null: false

      t.timestamps null: false
    end
  end
end
