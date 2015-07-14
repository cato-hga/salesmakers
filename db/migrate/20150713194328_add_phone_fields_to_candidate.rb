class AddPhoneFieldsToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :mobile_phone_valid, :boolean, null: false, default: true
    add_column :candidates, :other_phone_valid, :boolean, null: false, default: true
  end
end
