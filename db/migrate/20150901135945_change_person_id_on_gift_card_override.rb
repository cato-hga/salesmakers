class ChangePersonIdOnGiftCardOverride < ActiveRecord::Migration
  def change
    change_column :gift_card_overrides, :person_id, :integer, null: true
  end
end
