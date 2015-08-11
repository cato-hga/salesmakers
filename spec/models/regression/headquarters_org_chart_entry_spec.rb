require 'rails_helper'

RSpec.describe HeadquartersOrgChartEntry, regressor: true do

  # === Relations ===
  
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :department_name }
  it { is_expected.to have_db_column :department_id }
  it { is_expected.to have_db_column :position_name }
  it { is_expected.to have_db_column :position_id }
  it { is_expected.to have_db_column :person_name }
  it { is_expected.to have_db_column :person_id }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end