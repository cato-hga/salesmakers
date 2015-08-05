require 'rails_helper'

RSpec.describe CandidateDrugTest, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :scheduled }
  it { is_expected.to have_db_column :test_date }
  it { is_expected.to have_db_column :comments }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :candidate_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate_id }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end