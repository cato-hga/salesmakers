class CreateDirecTVLeadDismissalReasons < ActiveRecord::Migration
  def change
    create_table :directv_lead_dismissal_reasons do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: true

      t.timestamps null: false
    end
  end
end
