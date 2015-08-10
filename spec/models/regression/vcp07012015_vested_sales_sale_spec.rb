require 'rails_helper'

RSpec.describe VCP07012015VestedSalesSale, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :vonage_commission_period07012015 }
  it { is_expected.to belong_to :vonage_sale }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :vonage_commission_period07012015_id }
  it { is_expected.to have_db_column :vonage_sale_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :vested }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :vonage_commission_period07012015 }
  it { is_expected.to validate_presence_of :vonage_sale }
  it { is_expected.to validate_presence_of :person }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end