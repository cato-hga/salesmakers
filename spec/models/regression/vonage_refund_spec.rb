require 'rails_helper'

RSpec.describe VonageRefund, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :vonage_sale }
  it { is_expected.to belong_to :vonage_account_status_change }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :vonage_sale_id }
  it { is_expected.to have_db_column :vonage_account_status_change_id }
  it { is_expected.to have_db_column :refund_date }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["vonage_account_status_change_id"] }
  it { is_expected.to have_db_index ["vonage_sale_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :vonage_sale }
  it { is_expected.to validate_presence_of :vonage_account_status_change }
  it { is_expected.to validate_presence_of :refund_date }
  it { is_expected.to validate_presence_of :person_id }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end