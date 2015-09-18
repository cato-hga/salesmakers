require 'rails_helper'

RSpec.describe Ahoy::Event, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :visit }
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :visit_id }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :properties }
  it { is_expected.to have_db_column :time }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["person_id"] }
  it { is_expected.to have_db_index ["time"] }
  it { is_expected.to have_db_index ["visit_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end