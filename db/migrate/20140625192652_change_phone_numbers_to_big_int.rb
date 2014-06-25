class ChangePhoneNumbersToBigInt < ActiveRecord::Migration
  def self.up
    change_column :people, :office_phone, :bigint
    change_column :people, :mobile_phone, :bigint
    change_column :people, :home_phone, :bigint
  end

  def self.down
    change_column :people, :office_phone, :integer
    change_column :people, :mobile_phone, :integer
    change_column :people, :home_phone, :integer
  end
end
