require 'rails_helper'

RSpec.describe PersonAddress, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :line_1 }
  it { is_expected.to have_db_column :line_2 }
  it { is_expected.to have_db_column :city }
  it { is_expected.to have_db_column :state }
  it { is_expected.to have_db_column :zip }
  it { is_expected.to have_db_column :physical }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :latitude }
  it { is_expected.to have_db_column :longitude }
  it { is_expected.to have_db_column :time_zone }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :city }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :city }
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end