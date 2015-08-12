require 'rails_helper'

RSpec.describe WorkmarketField, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :workmarket_assignment }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :workmarket_assignment_id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :value }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["workmarket_assignment_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :name }
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :value }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :value }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :workmarket_assignment }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end