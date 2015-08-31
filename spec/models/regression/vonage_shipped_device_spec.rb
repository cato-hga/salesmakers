require 'rails_helper'

RSpec.describe VonageShippedDevice, regressor: true do

  # === Relations ===
  
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :po_number }
  it { is_expected.to have_db_column :carrier }
  it { is_expected.to have_db_column :tracking_number }
  it { is_expected.to have_db_column :ship_date }
  it { is_expected.to have_db_column :mac }
  it { is_expected.to have_db_column :device_type }
  it { is_expected.to have_db_column :vonage_device_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :po_number }
  it { is_expected.to validate_presence_of :ship_date }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end