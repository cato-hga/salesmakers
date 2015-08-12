require 'rails_helper'

RSpec.describe CommunicationLogEntry, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :loggable }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :loggable_id }
  it { is_expected.to have_db_column :loggable_type }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :person_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :loggable }
  it { is_expected.to validate_presence_of :person }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end