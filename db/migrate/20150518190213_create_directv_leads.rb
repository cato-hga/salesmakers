class CreateDirecTVLeads < ActiveRecord::Migration
  def change
    create_table :directv_leads do |t|
      t.boolean :active, default: true, null: false
      t.integer :directv_customer_id, null: false
      t.text :comments
      t.date :follow_up_by
      t.timestamps null: false
    end
  end
end
