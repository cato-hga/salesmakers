require 'rails_helper'

RSpec.describe WorkmarketAttachment, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :workmarket_assignment }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :workmarket_assignment_id }
  it { is_expected.to have_db_column :filename }
  it { is_expected.to have_db_column :url }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :guid }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["workmarket_assignment_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :filename }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :filename }
  it { is_expected.to allow_value(Faker::Lorem.characters(14)).for :url }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(13)).for :url }
  it { is_expected.to allow_value(Faker::Lorem.characters(1)).for :guid }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(0)).for :guid }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :workmarket_assignment }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end