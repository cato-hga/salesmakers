require 'rails_helper'

RSpec.describe VCP07012015HPSShift, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :vonage_commission_period07012015 }
  it { is_expected.to belong_to :shift }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :vonage_commission_period07012015_id }
  it { is_expected.to have_db_column :shift_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :hours }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :vonage_commission_period07012015 }
  it { is_expected.to validate_presence_of :shift }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :hours }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end