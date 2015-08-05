require 'rails_helper'

RSpec.describe CandidateReconciliation, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :status }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate_id }
  it { is_expected.to validate_presence_of :status }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:status).with(["not_contacted", "contacted_awaiting_response", "ready_for_training_location_available", "ready_for_training_location_full", "working", "nos", "needs_work_location", "in_training"]) }
  
end