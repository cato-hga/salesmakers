class AddIndexesToVonageComp07012015 < ActiveRecord::Migration
  def change
    add_index :vcp07012015_hps_shifts, [:vonage_commission_period07012015_id, :person_id], name: 'vcp_hps_shifts_report'
    add_index :vcp07012015_hps_sales, [:vonage_commission_period07012015_id, :person_id], name: 'vcp_hps_sales_report'
    add_index :vcp07012015_vested_sales_shifts, [:vonage_commission_period07012015_id, :person_id], name: 'vcp_vs_shifts_report'
    add_index :vcp07012015_vested_sales_sales, [:vonage_commission_period07012015_id, :person_id], name: 'vcp_vs_sales_report'
  end
end
