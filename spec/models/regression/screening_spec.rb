require 'rails_helper'

RSpec.describe Screening, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :sex_offender_check }
  it { is_expected.to have_db_column :public_background_check }
  it { is_expected.to have_db_column :private_background_check }
  it { is_expected.to have_db_column :drug_screening }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:sex_offender_check).with(["sex_offender_check_incomplete", "sex_offender_check_failed", "sex_offender_check_passed"]) }
  it { is_expected.to define_enum_for(:public_background_check).with(["public_background_check_incomplete", "public_background_check_failed", "public_background_check_passed"]) }
  it { is_expected.to define_enum_for(:private_background_check).with(["private_background_check_not_initiated", "private_background_check_initiated", "private_background_check_failed", "private_background_check_passed"]) }
  it { is_expected.to define_enum_for(:drug_screening).with(["drug_screening_not_sent", "drug_screening_sent", "drug_screening_failed", "drug_screening_passed"]) }
  
end