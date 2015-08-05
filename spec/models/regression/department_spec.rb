require 'rails_helper'

RSpec.describe Department, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :positions }
  it { is_expected.to have_many :people }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :corporate }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end