require 'rails_helper'

RSpec.describe Permission, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :permission_group }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :key }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :permission_group_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["permission_group_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :key }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :key }
  it { is_expected.to allow_value(Faker::Lorem.characters(10)).for :description }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(9)).for :description }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :permission_group }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end