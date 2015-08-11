require 'rails_helper'

RSpec.describe PersonPayRate, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :wage_type }
  it { is_expected.to have_db_column :rate }
  it { is_expected.to have_db_column :effective_date }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :connect_business_partner_salary_category_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :wage_type }
  it { is_expected.to validate_presence_of :rate }
  it { is_expected.to validate_presence_of :effective_date }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:rate).is_greater_than(7.5) }
  it { is_expected.not_to validate_numericality_of(:rate).is_greater_than(6.5) }

  
  # === Enums ===
  it { is_expected.to define_enum_for(:wage_type).with(["hourly", "salary"]) }
  
end