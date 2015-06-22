class ChangeSMSDailyChecks < ActiveRecord::Migration
  def change
    remove_column :sms_daily_checks, :out_time
    remove_column :sms_daily_checks, :in_time
    add_column :sms_daily_checks, :out_time, :datetime
    add_column :sms_daily_checks, :in_time, :datetime
  end
end
