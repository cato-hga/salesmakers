require 'rails_helper'

RSpec.describe PersonArea, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :area }
  
  it { is_expected.to have_many :versions }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :area_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :manages }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["area_id"] }
  it { is_expected.to have_db_index ["area_id", "person_id"] }
  it { is_expected.to have_db_index ["person_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :area }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end