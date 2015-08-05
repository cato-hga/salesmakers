require 'rails_helper'

RSpec.describe ComcastCustomerNote, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :comcast_customer }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :comcast_customer_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :note }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["comcast_customer_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :note }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :note }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :comcast_customer }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end