require 'rails_helper'

RSpec.describe DropOffReason, regressor: true do

  # === Relations ===
  
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :eligible_for_reschedule }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :active }
  it { is_expected.to validate_presence_of :eligible_for_reschedule }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end