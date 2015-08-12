require 'rails_helper'

RSpec.describe ClientRepresentative, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :client }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :client_id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :password_digest }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["client_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(72)).for :password }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(73)).for :password }
  it { is_expected.to allow_value(Faker::Lorem.characters(6)).for :password }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(5)).for :password }
  it { is_expected.to allow_value(Faker::Lorem.characters(3)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(2)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :client }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end