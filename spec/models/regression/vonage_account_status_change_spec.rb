require 'rails_helper'

RSpec.describe VonageAccountStatusChange, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :vonage_refunds }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :mac }
  it { is_expected.to have_db_column :account_start_date }
  it { is_expected.to have_db_column :account_end_date }
  it { is_expected.to have_db_column :status }
  it { is_expected.to have_db_column :termination_reason }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :account_start_date }
  it { is_expected.to validate_presence_of :status }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:status).with(["active", "grace", "suspended", "terminated"]) }
  
end