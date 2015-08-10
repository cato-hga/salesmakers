require 'rails_helper'

RSpec.describe LogEntry, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :trackable }
  it { is_expected.to belong_to :referenceable }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :action }
  it { is_expected.to have_db_column :comment }
  it { is_expected.to have_db_column :trackable_id }
  it { is_expected.to have_db_column :trackable_type }
  it { is_expected.to have_db_column :referenceable_id }
  it { is_expected.to have_db_column :referenceable_type }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["referenceable_type", "referenceable_id"] }
  it { is_expected.to have_db_index ["trackable_type", "trackable_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :action }
  it { is_expected.to validate_presence_of :trackable }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end