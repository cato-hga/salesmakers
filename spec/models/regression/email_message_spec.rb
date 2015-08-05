require 'rails_helper'

RSpec.describe EmailMessage, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :to_person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :from_email }
  it { is_expected.to have_db_column :to_email }
  it { is_expected.to have_db_column :to_person_id }
  it { is_expected.to have_db_column :content }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :subject }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["to_person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :subject }
  it { is_expected.to validate_presence_of :content }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end