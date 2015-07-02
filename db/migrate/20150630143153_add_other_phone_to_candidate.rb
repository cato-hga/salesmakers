class AddOtherPhoneToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :other_phone, :string
  end
end
