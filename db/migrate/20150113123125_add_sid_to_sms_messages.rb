class AddSidToSMSMessages < ActiveRecord::Migration
  def self.up
    SMSMessage.destroy_all
    add_column :sms_messages, :sid, :string, null: false
  end

  def self.down
    remove_column :sms_messages, :sid
  end
end
