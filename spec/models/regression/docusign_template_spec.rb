require 'rails_helper'

RSpec.describe DocusignTemplate, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :project }
  
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :template_guid }
  it { is_expected.to have_db_column :state }
  it { is_expected.to have_db_column :document_type }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :project_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["project_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :template_guid }
  it { is_expected.to validate_presence_of :document_type }
  it { is_expected.to validate_presence_of :project }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:document_type).with(["nhp", "paf", "nos"]) }
  
end