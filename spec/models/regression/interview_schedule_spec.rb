require 'rails_helper'

RSpec.describe InterviewSchedule, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  it { is_expected.to belong_to :person }
  
  it { is_expected.to have_many :log_entries }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :interview_date }
  it { is_expected.to have_db_column :start_time }
  it { is_expected.to have_db_column :active }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["candidate_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate_id }
  it { is_expected.to validate_presence_of :person_id }
  it { is_expected.to validate_presence_of :start_time }
  it { is_expected.to validate_presence_of :interview_date }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end