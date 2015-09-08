require 'rails_helper'

RSpec.describe Person, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :supervisor }
  it { is_expected.to belong_to :position }
  it { is_expected.to belong_to :connect_user }
  it { is_expected.to have_one :group_me_user }
  it { is_expected.to have_one :candidate }
  it { is_expected.to have_one :screening }
  it { is_expected.to have_one :most_recent_employment }
  it { is_expected.to have_many :versions }
  it { is_expected.to have_many :log_entries }
  it { is_expected.to have_many :person_areas }
  it { is_expected.to have_many :device_deployments }
  it { is_expected.to have_many :devices }
  it { is_expected.to have_many :communication_log_entries }
  it { is_expected.to have_many :group_me_posts }
  it { is_expected.to have_many :employments }
  it { is_expected.to have_many :person_addresses }
  it { is_expected.to have_many :vonage_sale_payouts }
  it { is_expected.to have_many :vonage_sales }
  it { is_expected.to have_many :vonage_refunds }
  it { is_expected.to have_many :vonage_paycheck_negative_balances }
  it { is_expected.to have_many :sprint_sales }
  it { is_expected.to have_many :candidate_notes }
  it { is_expected.to have_many :comcast_customer_notes }
  it { is_expected.to have_many :directv_customer_notes }
  it { is_expected.to have_many :shifts }
  it { is_expected.to have_many :person_pay_rates }
  it { is_expected.to have_many :person_client_areas }
  it { is_expected.to have_many :vcp07012015_hps_sales }
  it { is_expected.to have_many :vcp07012015_hps_shifts }
  it { is_expected.to have_many :vcp07012015_vested_sales_shifts }
  it { is_expected.to have_many :roster_verifications }
  it { is_expected.to have_many :person_punches }
  it { is_expected.to have_many :permissions }
  it { is_expected.to have_many :areas }
  it { is_expected.to have_many :candidate_contacts }
  it { is_expected.to have_many :day_sales_counts }
  it { is_expected.to have_many :sales_performance_ranks }
  it { is_expected.to have_many :employees }
  it { is_expected.to have_many :roster_verification_sessions }
  it { is_expected.to have_many :to_sms_messages }
  it { is_expected.to have_many :from_sms_messages }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :first_name }
  it { is_expected.to have_db_column :last_name }
  it { is_expected.to have_db_column :display_name }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :personal_email }
  it { is_expected.to have_db_column :position_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
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

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["connect_user_id"] }
  it { is_expected.to have_db_index ["group_me_user_id"] }
  it { is_expected.to have_db_index ["position_id"] }
  it { is_expected.to have_db_index ["supervisor_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :first_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :first_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :last_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :last_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :display_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :display_name }

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:vonage_tablet_approval_status).with(["no_decision", "denied", "approved"]) }
  it { is_expected.to define_enum_for(:sprint_prepaid_asset_approval_status).with(["prepaid_no_decision", "prepaid_denied", "prepaid_approved"]) }
  
end