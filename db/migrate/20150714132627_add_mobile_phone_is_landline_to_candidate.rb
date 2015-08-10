class AddMobilePhoneIsLandlineToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :mobile_phone_is_landline, :boolean, null: false, default: false
  end
end
