class CreateVCP07012015VestedSalesSales < ActiveRecord::Migration
  def change
    create_table :vcp07012015_vested_sales_sales do |t|
      t.integer :vonage_commission_period07012015_id, null: false
      t.integer :vonage_sale_id, null: false
      t.integer :person_id, null: false
      t.boolean :vested, null: false, default: false

      t.timestamps null: false
    end
  end
end
