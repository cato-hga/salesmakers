require 'rails_helper'

RSpec.describe HistoricalPerson, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :supervisor }
  it { is_expected.to belong_to :position }
  it { is_expected.to belong_to :connect_user }
  
  it { is_expected.to have_many :historical_person_areas }
  it { is_expected.to have_many :historical_person_client_areas }
  it { is_expected.to have_many :historical_areas }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :first_name }
  it { is_expected.to have_db_column :last_name }
  it { is_expected.to have_db_column :display_name }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :personal_email }
  it { is_expected.to have_db_column :position_id }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :connect_user_id }
  it { is_expected.to have_db_column :supervisor_id }
  it { is_expected.to have_db_column :office_phone }
  it { is_expected.to have_db_column :mobile_phone }
  it { is_expected.to have_db_column :home_phone }
  it { is_expected.to have_db_column :eid }
  it { is_expected.to have_db_column :groupme_access_token }
  it { is_expected.to have_db_column :groupme_token_updated }
  it { is_expected.to have_db_column :group_me_user_id }
  it { is_expected.to have_db_column :last_seen }
  it { is_expected.to have_db_column :changelog_entry_id }
  it { is_expected.to have_db_column :vonage_tablet_approval_status }
  it { is_expected.to have_db_column :passed_asset_hours_requirement }
  it { is_expected.to have_db_column :sprint_prepaid_asset_approval_status }
  it { is_expected.to have_db_column :update_position_from_connect }
  it { is_expected.to have_db_column :mobile_phone_valid }
  it { is_expected.to have_db_column :home_phone_valid }
  it { is_expected.to have_db_column :office_phone_valid }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :date }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["date"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :first_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :first_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :last_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :last_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :display_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :display_name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :date }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:vonage_tablet_approval_status).with(["no_decision", "denied", "approved"]) }
  it { is_expected.to define_enum_for(:sprint_prepaid_asset_approval_status).with(["prepaid_no_decision", "prepaid_denied", "prepaid_approved"]) }
  
end