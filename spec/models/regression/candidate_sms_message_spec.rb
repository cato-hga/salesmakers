require 'rails_helper'

RSpec.describe CandidateSMSMessage, regressor: true do

  # === Relations ===
  
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :text }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(160)).for :text }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(161)).for :text }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :text }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end