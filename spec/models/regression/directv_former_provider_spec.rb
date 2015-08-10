require 'rails_helper'

RSpec.describe DirecTVFormerProvider, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :directv_sale }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :directv_sale_id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["directv_sale_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end