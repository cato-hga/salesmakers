require 'rails_helper'

RSpec.describe ReportQuery, regressor: true do

  # === Relations ===
  
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :category_name }
  it { is_expected.to have_db_column :database_name }
  it { is_expected.to have_db_column :query }
  it { is_expected.to have_db_column :permission_key }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :has_date_range }
  it { is_expected.to have_db_column :start_date_default }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :category_name }
  it { is_expected.to validate_presence_of :database_name }
  it { is_expected.to validate_presence_of :query }
  it { is_expected.to validate_presence_of :permission_key }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end