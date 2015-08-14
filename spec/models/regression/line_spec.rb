require 'rails_helper'

RSpec.describe Line, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :technology_service_provider }
  it { is_expected.to have_one :device }
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :identifier }
  it { is_expected.to have_db_column :contract_end_date }
  it { is_expected.to have_db_column :technology_service_provider_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["technology_service_provider_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :identifier }
  it { is_expected.to validate_presence_of :contract_end_date }
  it { is_expected.to validate_presence_of :technology_service_provider }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end