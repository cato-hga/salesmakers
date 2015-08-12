require 'rails_helper'

RSpec.describe TrainingAvailability, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :training_unavailability_reason }
  it { is_expected.to belong_to :candidate }
  
  

  # === Nested Attributes ===
  it { is_expected.to accept_nested_attributes_for :candidate }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :able_to_attend }
  it { is_expected.to have_db_column :training_unavailability_reason_id }
  it { is_expected.to have_db_column :comments }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :candidate_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }
  it { is_expected.to have_db_index ["training_unavailability_reason_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end