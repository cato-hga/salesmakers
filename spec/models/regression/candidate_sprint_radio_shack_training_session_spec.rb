require 'rails_helper'

RSpec.describe CandidateSprintRadioShackTrainingSession, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  it { is_expected.to belong_to :sprint_radio_shack_training_session }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :sprint_radio_shack_training_session_id }
  it { is_expected.to have_db_column :sprint_roster_status }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate }
  it { is_expected.to validate_presence_of :sprint_radio_shack_training_session }
  it { is_expected.to validate_presence_of :sprint_roster_status }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:sprint_roster_status).with(["roster_status_pending", "sprint_submitted", "sprint_confirmed", "sprint_rejected", "sprint_preconfirmed"]) }
  
end