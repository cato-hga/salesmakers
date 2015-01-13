class CreateSMSMessages < ActiveRecord::Migration
  def change
    create_table :sms_messages do |t|
      t.string :from_num, null: false
      t.string :to_num, null: false
      t.integer :from_person_id
      t.integer :to_person_id
      t.boolean :inbound, default: false
      t.integer :reply_to_sms_message_id
      t.boolean :replied_to, default: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
