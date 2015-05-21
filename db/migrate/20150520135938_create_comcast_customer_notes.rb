class CreateComcastCustomerNotes < ActiveRecord::Migration
  def change
    create_table :comcast_customer_notes do |t|
      t.integer :comcast_customer_id, null: false
      t.integer :person_id, null: false
      t.text :note, null: false

      t.timestamps null: false
    end
  end
end
