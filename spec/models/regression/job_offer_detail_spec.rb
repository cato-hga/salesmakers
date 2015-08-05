require 'rails_helper'

RSpec.describe JobOfferDetail, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :sent }
  it { is_expected.to have_db_column :completed }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :envelope_guid }
  it { is_expected.to have_db_column :completed_by_candidate }
  it { is_expected.to have_db_column :completed_by_advocate }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate_id }
  it { is_expected.to validate_presence_of :sent }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end