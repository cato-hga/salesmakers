class AddPhoneFieldsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :mobile_phone_valid, :boolean, null: false, default: true
    add_column :people, :home_phone_valid, :boolean, null: false, default: true
    add_column :people, :office_phone_valid, :boolean, null: false, default: true
  end
end
