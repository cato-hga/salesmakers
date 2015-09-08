require 'rails_helper'

RSpec.describe DeviceModel, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :device_manufacturer }
  
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :device_manufacturer_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["device_manufacturer_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(3)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(2)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :device_manufacturer }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end