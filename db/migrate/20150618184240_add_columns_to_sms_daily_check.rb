class AddColumnsToSMSDailyCheck < ActiveRecord::Migration
  def change
    add_column :sms_daily_checks, :roll_call, :boolean
    add_column :sms_daily_checks, :blueforce_geotag, :boolean
    add_column :sms_daily_checks, :accountability_checkin_1, :boolean
    add_column :sms_daily_checks, :accountability_checkin_2, :boolean
    add_column :sms_daily_checks, :accountability_checkin_3, :boolean
    add_column :sms_daily_checks, :sales, :integer
    add_column :sms_daily_checks, :notes, :text
  end
end
