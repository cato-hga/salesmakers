require 'rails_helper'

RSpec.describe AbstractPrescreenAnswer, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :candidate }
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :project }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :candidate_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :project_id }
  it { is_expected.to have_db_column :answers }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :candidate }
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :project }
  it { is_expected.to validate_presence_of :answers }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end