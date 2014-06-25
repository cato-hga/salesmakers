class AddPhoneNumbersToPeople < ActiveRecord::Migration
  def change
    add_column :people, :office_phone, :integer
    add_column :people, :mobile_phone, :integer
    add_column :people, :home_phone, :integer
  end
end