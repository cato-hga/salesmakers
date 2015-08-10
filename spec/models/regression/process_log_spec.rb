require 'rails_helper'

RSpec.describe ProcessLog, regressor: true do

  # === Relations ===
  
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :process_class }
  it { is_expected.to have_db_column :records_processed }
  it { is_expected.to have_db_column :notes }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :process_class }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end