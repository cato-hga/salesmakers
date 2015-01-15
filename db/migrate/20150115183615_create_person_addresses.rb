class CreatePersonAddresses < ActiveRecord::Migration
  def change
    create_table :person_addresses do |t|
      t.integer :person_id, null: false
      t.string :line_1, null: false
      t.string :line_2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.boolean :physical, null: false, default: true

      t.timestamps
    end
  end
end
