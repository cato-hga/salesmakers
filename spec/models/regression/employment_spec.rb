require 'rails_helper'

RSpec.describe Employment, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :start }
  it { is_expected.to have_db_column :end }
  it { is_expected.to have_db_column :end_reason }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :start }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end