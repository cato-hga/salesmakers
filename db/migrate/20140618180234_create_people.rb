class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :display_name, null: false
      t.string :email, null: false
      t.string :personal_email
      t.integer :position_id, null: false

      t.timestamps
    end
  end
end
