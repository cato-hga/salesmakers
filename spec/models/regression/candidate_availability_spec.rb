require 'rails_helper'

RSpec.describe CandidateAvailability, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :monday_first }
  it { is_expected.to have_db_column :monday_second }
  it { is_expected.to have_db_column :monday_third }
  it { is_expected.to have_db_column :tuesday_first }
  it { is_expected.to have_db_column :tuesday_second }
  it { is_expected.to have_db_column :tuesday_third }
  it { is_expected.to have_db_column :wednesday_first }
  it { is_expected.to have_db_column :wednesday_second }
  it { is_expected.to have_db_column :wednesday_third }
  it { is_expected.to have_db_column :thursday_first }
  it { is_expected.to have_db_column :thursday_second }
  it { is_expected.to have_db_column :thursday_third }
  it { is_expected.to have_db_column :friday_first }
  it { is_expected.to have_db_column :friday_second }
  it { is_expected.to have_db_column :friday_third }
  it { is_expected.to have_db_column :saturday_first }
  it { is_expected.to have_db_column :saturday_second }
  it { is_expected.to have_db_column :saturday_third }
  it { is_expected.to have_db_column :sunday_first }
  it { is_expected.to have_db_column :sunday_second }
  it { is_expected.to have_db_column :sunday_third }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :comment }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate_id }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end