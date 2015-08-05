require 'rails_helper'

RSpec.describe HistoricalLocationClientArea, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :historical_location }
  it { is_expected.to belong_to :historical_client_area }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :historical_location_id }
  it { is_expected.to have_db_column :historical_client_area_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :date }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["date"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :historical_location }
  it { is_expected.to validate_presence_of :historical_client_area }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end