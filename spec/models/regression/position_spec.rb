require 'rails_helper'

RSpec.describe Position, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :department }
  
  it { is_expected.to have_many :people }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :leadership }
  it { is_expected.to have_db_column :all_field_visibility }
  it { is_expected.to have_db_column :all_corporate_visibility }
  it { is_expected.to have_db_column :department_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :field }
  it { is_expected.to have_db_column :hq }
  it { is_expected.to have_db_column :twilio_number }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["department_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(4)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(3)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :department }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end