class CreateSMSDailyChecks < ActiveRecord::Migration
  def change
    create_table :sms_daily_checks do |t|
      t.date :date, null: false
      t.integer :person_id, null: false
      t.integer :sms_id, null: false
      t.integer :in_time
      t.integer :out_time
      t.boolean :check_in_uniform
      t.boolean :check_in_on_time
      t.boolean :check_in_inside_store
      t.boolean :check_out_on_time
      t.boolean :check_out_inside_store
      t.boolean :off_day

      t.timestamps null: false
    end
  end
end
