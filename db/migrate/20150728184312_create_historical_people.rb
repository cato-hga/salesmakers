class CreateHistoricalPeople < ActiveRecord::Migration
  def change
    create_table :historical_people do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :display_name, null: false
      t.string :email, null: false
      t.string :personal_email
      t.integer :position_id
      t.boolean :active, null: false, default: true
      t.string :connect_user_id
      t.integer :supervisor_id
      t.string :office_phone
      t.string :mobile_phone
      t.string :home_phone
      t.integer :eid
      t.string :groupme_access_token
      t.datetime :groupme_token_updated
      t.string :group_me_user_id
      t.datetime :last_seen
      t.integer :changelog_entry_id
      t.integer :vonage_tablet_approval_status, null: false, default: 0
      t.boolean :passed_asset_hours_requirement, null: false, default: false
      t.integer :sprint_prepaid_asset_approval_status, null: false, default: 0
      t.boolean :update_position_from_connect, null: false, default: true
      t.boolean :mobile_phone_valid, null: false, default: true
      t.boolean :home_phone_valid, null: false, default: true
      t.boolean :office_phone_valid, null: false, default: true

      t.timestamps null: false
    end
  end
end
