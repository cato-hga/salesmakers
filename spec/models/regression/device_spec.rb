require 'rails_helper'

RSpec.describe Device, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :device_model }
  it { is_expected.to belong_to :line }
  it { is_expected.to belong_to :person }
  it { is_expected.to have_one :device_manufacturer }
  it { is_expected.to have_many :device_deployments }
  it { is_expected.to have_many :device_notes }
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :identifier }
  it { is_expected.to have_db_column :serial }
  it { is_expected.to have_db_column :device_model_id }
  it { is_expected.to have_db_column :line_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["device_model_id"] }
  it { is_expected.to have_db_index ["line_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(6)).for :serial }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(5)).for :serial }
  it { is_expected.to allow_value(Faker::Lorem.characters(4)).for :identifier }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(3)).for :identifier }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :serial }
  it { is_expected.to validate_presence_of :identifier }
  it { is_expected.to validate_presence_of :device_model }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end