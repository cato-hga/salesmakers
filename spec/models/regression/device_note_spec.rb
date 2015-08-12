require 'rails_helper'

RSpec.describe DeviceNote, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :device }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :device_id }
  it { is_expected.to have_db_column :note }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :note }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :note }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :device }
  it { is_expected.to validate_presence_of :person }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end