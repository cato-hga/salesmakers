require 'rails_helper'

RSpec.describe RadioShackLocationSchedule, regressor: true do

  # === Relations ===
  
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :monday }
  it { is_expected.to have_db_column :tuesday }
  it { is_expected.to have_db_column :wednesday }
  it { is_expected.to have_db_column :thursday }
  it { is_expected.to have_db_column :friday }
  it { is_expected.to have_db_column :saturday }
  it { is_expected.to have_db_column :sunday }

  # === Database (Indexes) ===
  

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :active }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :monday }
  it { is_expected.to validate_presence_of :tuesday }
  it { is_expected.to validate_presence_of :wednesday }
  it { is_expected.to validate_presence_of :thursday }
  it { is_expected.to validate_presence_of :friday }
  it { is_expected.to validate_presence_of :saturday }
  it { is_expected.to validate_presence_of :sunday }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end