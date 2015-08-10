require 'rails_helper'

RSpec.describe WorkmarketLocation, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :workmarket_assignments }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :workmarket_location_num }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :location_number }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :workmarket_location_num }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end