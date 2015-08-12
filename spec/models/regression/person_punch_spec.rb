require 'rails_helper'

RSpec.describe PersonPunch, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :person }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :identifier }
  it { is_expected.to have_db_column :punch_time }
  it { is_expected.to have_db_column :in_or_out }
  it { is_expected.to have_db_column :person_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["identifier"] }
  it { is_expected.to have_db_index ["in_or_out"] }
  it { is_expected.to have_db_index ["punch_time"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :identifier }
  it { is_expected.to validate_presence_of :punch_time }
  it { is_expected.to validate_presence_of :in_or_out }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:in_or_out).with(["in", "out"]) }
  
end