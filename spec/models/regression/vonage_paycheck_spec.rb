require 'rails_helper'

RSpec.describe VonagePaycheck, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :vonage_sale_payouts }
  it { is_expected.to have_many :vonage_paycheck_negative_balances }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :wages_start }
  it { is_expected.to have_db_column :wages_end }
  it { is_expected.to have_db_column :commission_start }
  it { is_expected.to have_db_column :commission_end }
  it { is_expected.to have_db_column :cutoff }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :wages_start }
  it { is_expected.to validate_presence_of :wages_end }
  it { is_expected.to validate_presence_of :commission_start }
  it { is_expected.to validate_presence_of :commission_end }
  it { is_expected.to validate_presence_of :cutoff }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end