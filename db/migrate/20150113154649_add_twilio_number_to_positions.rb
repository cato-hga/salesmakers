class AddTwilioNumberToPositions < ActiveRecord::Migration
  def self.up
    add_column :positions, :twilio_number, :string
    pos_admin = Position.find_by_name 'System Administrator'
    pos_ssd = Position.find_by_name 'Senior Software Developer'
    pos_sd = Position.find_by_name 'Software Developer'
    pos_itd = Position.find_by_name 'Information Technology Director'
    pos_itst = Position.find_by_name 'Information Technology Support Technician'
    num = '+17272286225'
    pos_admin.twilio_number = num if pos_admin
    pos_ssd.twilio_number = num if pos_ssd
    pos_sd.twilio_number = num if pos_sd
    pos_itd.twilio_number = num if pos_itd
    pos_itst.twilio_number = num if pos_itst
  end

  def self.down
    remove_column :positions, :twilio_number
  end
end
