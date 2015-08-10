require 'rails_helper'

RSpec.describe SprintRadioShackTrainingSession, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :candidate_sprint_radio_shack_training_sessions }
  it { is_expected.to have_many :candidates }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :start_date }
  it { is_expected.to have_db_column :locked }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :start_date }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end