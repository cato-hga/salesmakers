class CreateComcastLeads < ActiveRecord::Migration
  def change
    create_table :comcast_leads do |t|
      t.integer :comcast_customer_id, null: false
      t.date :follow_up_by
      t.boolean :tv, null: false, default: false
      t.boolean :internet, null: false, default: false
      t.boolean :phone, null: false, default: false
      t.boolean :security, null: false, default: false
      t.boolean :ok_to_call_and_text, null: false, default: false
      t.text :comments

      t.timestamps null: false
    end
  end
end
