class CreateEmailMessages < ActiveRecord::Migration
  def change
    create_table :email_messages do |t|
      t.string :from_email, null: false
      t.string :to_email, null: false
      t.integer :to_person_id
      t.text :content, null: false

      t.timestamps
    end
  end
end
