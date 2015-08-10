require 'rails_helper'

RSpec.describe VonageRepSalePayoutBracket, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :area }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :per_sale }
  it { is_expected.to have_db_column :area_id }
  it { is_expected.to have_db_column :sales_minimum }
  it { is_expected.to have_db_column :sales_maximum }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["area_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :per_sale }
  it { is_expected.to validate_presence_of :area }
  it { is_expected.to validate_presence_of :sales_minimum }
  it { is_expected.to validate_presence_of :sales_maximum }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end