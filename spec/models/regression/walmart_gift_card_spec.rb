require 'rails_helper'

RSpec.describe WalmartGiftCard, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :vonage_sale }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :used }
  it { is_expected.to have_db_column :card_number }
  it { is_expected.to have_db_column :link }
  it { is_expected.to have_db_column :challenge_code }
  it { is_expected.to have_db_column :unique_code }
  it { is_expected.to have_db_column :pin }
  it { is_expected.to have_db_column :balance }
  it { is_expected.to have_db_column :purchase_date }
  it { is_expected.to have_db_column :purchase_amount }
  it { is_expected.to have_db_column :store_number }
  it { is_expected.to have_db_column :vonage_sale_id }
  it { is_expected.to have_db_column :overridden }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0.0) }
  it { is_expected.not_to validate_numericality_of(:balance).is_greater_than_or_equal_to(-1.0) }
  it { is_expected.to validate_numericality_of(:purchase_amount).is_greater_than_or_equal_to(0.0) }
  it { is_expected.not_to validate_numericality_of(:purchase_amount).is_greater_than_or_equal_to(-1.0) }

  
  # === Enums ===
  
  
end