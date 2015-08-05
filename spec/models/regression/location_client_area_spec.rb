require 'rails_helper'

RSpec.describe LocationClientArea, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :location }
  it { is_expected.to belong_to :client_area }
  
  it { is_expected.to have_many :versions }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :location_id }
  it { is_expected.to have_db_column :client_area_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :location }
  it { is_expected.to validate_presence_of :client_area }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end