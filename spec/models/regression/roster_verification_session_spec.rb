require 'rails_helper'

RSpec.describe RosterVerificationSession, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :creator }
  
  it { is_expected.to have_many :roster_verifications }

  # === Nested Attributes ===
  it { is_expected.to accept_nested_attributes_for :roster_verifications }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :creator_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :missing_employees }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :creator }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end