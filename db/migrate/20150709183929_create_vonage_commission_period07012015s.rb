class CreateVonageCommissionPeriod07012015s < ActiveRecord::Migration
  def change
    create_table :vonage_commission_period07012015s do |t|
      t.string :name, null: false
      t.date :hps_start
      t.date :hps_end
      t.date :vested_sales_start
      t.date :vested_sales_end
      t.datetime :cutoff, null: false

      t.timestamps null: false
    end
  end
end
