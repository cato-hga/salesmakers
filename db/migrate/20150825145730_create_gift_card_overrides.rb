class CreateGiftCardOverrides < ActiveRecord::Migration
  def change
    create_table :gift_card_overrides do |t|
      t.integer :creator_id, null: false
      t.integer :person_id, null: false
      t.string :original_card_number
      t.string :ticket_number
      t.string :override_card_number, null: false

      t.timestamps null: false
    end
  end
end
