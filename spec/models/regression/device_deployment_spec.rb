require 'rails_helper'

RSpec.describe DeviceDeployment, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :device }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :device_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :started }
  it { is_expected.to have_db_column :ended }
  it { is_expected.to have_db_column :tracking_number }
  it { is_expected.to have_db_column :comment }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["device_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :device }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :started }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end