class CreateComcastCustomers < ActiveRecord::Migration
  def change
    create_table :comcast_customers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :mobile_phone
      t.string :other_phone
      t.integer :person_id, nulL: false
      t.text :comments

      t.timestamps null: false
    end
  end
end
