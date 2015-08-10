class ChangePhoneNumbersToStrings < ActiveRecord::Migration
  def self.up
    change_column :people, :office_phone, :string
    change_column :people, :mobile_phone, :string
    change_column :people, :home_phone, :string
  end

  def self.down
    change_column :people, :office_phone, :bigint
    change_column :people, :mobile_phone, :bigint
    change_column :people, :home_phone, :bigint
  end
end
